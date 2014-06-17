# =============================================================
# * bootstrap-tree.js v0.3
# * http://twitter.github.com/cutterbl/Bootstrap-Tree
# * 
# * Inspired by Twitter Bootstrap, with credit to bits of code
# * from all over.
# * =============================================================
# * Copyright 2012 Cutters Crossing.
# *
# * Licensed under the Apache License, Version 2.0 (the "License");
# * you may not use this file except in compliance with the License.
# * You may obtain a copy of the License at
# *
# * http://www.apache.org/licenses/LICENSE-2.0
# *
# * Unless required by applicable law or agreed to in writing, software
# * distributed under the License is distributed on an "AS IS" BASIS,
# * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# * See the License for the specific language governing permissions and
# * limitations under the License.
# * ============================================================ 
not ($) ->
  "use strict" # jshint ;_;
  loading = "<img src='/bootstrap-tree/img/ajax-loader.gif' class='indicator' /> Loading ..."
  
  # TREE CLASS DEFINITION
  #   * ========================= 
  Tree = (element, options) ->
    @$element = $(element)
    @$tree = @$element.closest(".tree")
    @parentage = GetParentage(@$element)
    @options = $.extend({}, $.fn.tree.defaults, options)
    @$parent = $(@options.parent)  if @options.parent
    @options.toggle and @toggle()

  Tree:: =
    constructor: Tree
    toggle: ->
      a = undefined
      n = undefined
      s = undefined
      currentStatus = @$element.hasClass("in")
      eventName = (if (not currentStatus) then "openbranch" else "closebranch")
      @$parent[(if currentStatus then "addClass" else "removeClass")] "closed"
      @$element[(if currentStatus then "removeClass" else "addClass")] "in"
      @_load()  if @options.href
      n = @node()
      
      # 'Action' (open|close) event
      a = $.Event(eventName,
        node: n
      )
      
      # 'Select' event
      s = $.Event("nodeselect",
        node: n
      )
      @$parent.trigger(a).trigger s

    _load: ->
      data = $.extend({}, @options)
      el = @$element
      $this = $(this)
      options = @options
      
      # some config data we don't need to pass in the post
      delete data.parent

      delete data.href

      delete data.callback

      $.post options.href, data, ((d, s, x) ->
        doc = undefined
        type = "html"
        if options.callback # If a callback was defined in the data parameters
          cb = window[options.callback].apply(el, [d, s, x]) # callbacks must return an object with 'doc' and 'type' keys
          doc = cb.doc or d
          type = cb.type or type
        else
          try
            doc = $.parseJSON(d)
            type = "json"
          catch err
            doc = d
          if type isnt "json"
            try
              doc = $.parseXML(d)
              type = "xml"
            catch err
              doc = d
        switch type
          when "html"
            el.html doc
          else
            $this[0]._buildOutput doc, type, el
      ), "html"

    _buildOutput: (doc, type, parent) ->
      nodes = @_buildNodes(doc, type)
      parent.empty().append @_createNodes(nodes)

    _createNodes: (nodes) ->
      els = []
      $this = $(this)
      $.each nodes, (ind, el) ->
        node = $("<li>")
        role = (if (el.leaf) then "leaf" else "branch")
        attributes = {}
        anchor = $("<a>")
        attributes.role = role
        unless el.leaf
          branch = $("<ul>").addClass("branch")
          attributes.class = "tree-toggle closed"
          attributes["data-toggle"] = "branch"
        attributes["data-value"] = el.value  if el.value
        attributes["data-itemid"] = el.id  if el.id
        for key of el # do we have some extras?
          attributes[key] = el[key]  if key.indexOf("data-") isnt -1
        attributes.href = (if (el.href) then el.href else "#")
        
        # trade the anchor for a span tag, if it's a leaf
        # and there's no href
        if el.leaf and attributes.href is "#"
          anchor = $("<span>")
          delete attributes.href
        anchor.attr attributes
        anchor.addClass el.cls  if el.cls
        if not el.leaf and el.expanded and el.children.length
          anchor.removeClass "closed"
          branch.addClass "in"
        anchor.html el.text
        node.append anchor
        if not el.leaf and el.children and el.children.length
          branch.append $this[0]._createNodes(el.children)
          node.append branch
        els.push node

      els

    _buildNodes: (doc, type) ->
      nodes = []
      $el = @$element
      if type is "json"
        nodes = @_parseJsonNodes(doc)
      else nodes = @_parseXmlNodes($(doc).find("nodes").children())  if type is "xml"
      nodes

    _parseJsonNodes: (doc) ->
      nodes = []
      $this = $(this)
      $.each doc, (ind, el) ->
        opts = {}
        boolChkArr = ["leaf", "expanded", "checkable", "checked"]
        for item of el
          nodeVal = (if (item isnt "children") then el[item] else $this[0]._parseJsonNodes(el.children))
          nodeVal = $.trim(nodeVal)  unless $.isArray(nodeVal)
          opts[item] = (if ($.inArray(item, boolChkArr) > -1) then SetBoolean(nodeVal) else nodeVal)  if nodeVal.length
        nodes.push new Node(opts)

      nodes

    _parseXmlNodes: (doc) ->
      nodes = []
      $this = $(this)
      boolChkArr = ["leaf", "expanded", "checkable", "checked"]
      $.each doc, (ind, el) ->
        opts = {}
        $el = $(el)
        $.each $el.children(), (x, i) ->
          $i = $(i)
          tagName = $i[0].nodeName
          nodeVal = (if (tagName isnt "children") then $i.text() else $this[0]._parseXmlNodes($i.children("node")))
          nodeVal = $.trim(nodeVal)  unless $.isArray(nodeVal)
          opts[tagName] = (if ($.inArray(tagName, boolChkArr) > -1) then SetBoolean(nodeVal) else nodeVal)  if nodeVal.length

        nodes.push new Node(opts)

      nodes

    getparentage: ->
      @parentage

    node: (el) ->
      el = el or $(this)
      node = $.extend(true, {}, (if (el[0] is $(this)[0]) then $(@$parent).data() else el.data()))
      node.branch = @$element
      node.parentage = @parentage
      node.el = (if (el[0] is $(this)[0]) then @$parent else el)
      delete node.parent

      node

  Node = (options) ->
    $.extend true, this,
      text: `undefined`
      leaf: false
      value: `undefined`
      expanded: false
      cls: `undefined`
      id: `undefined`
      href: `undefined`
      checkable: false
      checked: false
      children: []
    , options

  GetParentBranch = ($this) ->
    $this.closest("ul.branch").prev ".tree-toggle"

  GetParentage = ($this) ->
    arr = []
    tmp = undefined
    tmp = GetParentBranch($this)
    if tmp.length
      arr = GetParentage(tmp)
      arr.push tmp.attr("data-value") or tmp.text()
    arr

  
  ###
  FUNCTION SetBoolean
  
  Takes any value, and returns it's boolean equivalent.
  
  @param value (any)
  @return (boolean)
  ###
  SetBoolean = (value) ->
    value = $.trim(value)
    return false  if typeof value is "undefined" or value is null
    value = parseFloat(value)  if typeof value is "string" and not isNaN(value)
    if typeof value is "string"
      switch value.toLowerCase()
        when "true", "yes"
          return true
        when "false", "no"
          return false
    Boolean value

  
  # COLLAPSIBLE PLUGIN DEFINITION
  #   * ============================== 
  $.fn.tree = (option) ->
    @each ->
      $this = $(this)
      data = $this.data("tree")
      options = typeof option is "object" and option
      $this.data "tree", (data = new Tree(this, options))  unless data
      data[option]()  if typeof option is "string"


  $.fn.tree.defaults = toggle: true
  $.fn.tree.Constructor = Tree
  
  # COLLAPSIBLE DATA-API
  #   * ==================== 
  $ ->
    $("body").on "click.tree.data-api", "[data-toggle=branch]", (e) ->
      e.preventDefault()
      $this = $(this)
      target = $this.next(".branch")
      href = $this.attr("href")
      option = (if $(target).data("tree") then "toggle" else $this.data())
      href.replace /.*(?=#[^\s]+$)/, "" #strip for ie7
      target = $("<ul>").addClass("branch").append("<li>" + loading + "</li>").insertAfter($this)  unless target.length
      option.parent = $this
      option.href = (if (href isnt "#") then href else `undefined`)
      $(target).tree option
      false

    $("body").on "click.tree.data-api", "[role=leaf]", (e) ->
      $this = $(this)
      branch = $this.closest(".branch")
      
      # If not initialized, then create it
      unless $(branch).data("tree")
        $target = $(branch)
        branchlink = $target.prev("[data-toggle=branch]")
        branchdata = branchlink.data()
        href = branchlink.attr("href")
        href.replace /.*(?=#[^\s]+$)/, ""
        $target.tree $.extend({}, branchdata,
          toggle: false
          parent: branchlink
          href: (if (href isnt "#") then href else `undefined`)
        )
      e = $.Event("nodeselect",
        node: $(branch).data("tree").node($this)
      )
      $this.trigger e


(window.jQuery)