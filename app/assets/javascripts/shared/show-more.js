var showClassName = ".show-more"

$(document)
	.on("click", showClassName, function(e){
		
		var $showMore = $(this)
		
		showMore($showMore)
		
		e.preventDefault()
	})


var showMore = function($showMore){
	
		if ($showMore.hasClass("more")){
			$showMore.removeClass("more").find(".text").text("Show more")
			$($showMore.data("show")).find(".shown").removeClass("shown").fadeOut().addClass("hidden")
			$showMore.find(".glyphicon").addClass("glyphicon-chevron-down").removeClass("glyphicon-chevron-up")
		}else{
			$showMore.addClass("more").find(".text").text("Show less")
			$($showMore.data("show")).find(".hidden").hide().removeClass("hidden").addClass("shown").fadeIn()
			$showMore.find(".glyphicon").removeClass("glyphicon-chevron-down").addClass("glyphicon-chevron-up")
		}
		
}
