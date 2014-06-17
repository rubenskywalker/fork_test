var toggleClassName = ".toggle-style"

$(document)
	.on("click", toggleClassName, function(e){
		
		var $toggle = $(this)
		
		toggleActiveStyle($toggle)
		
		e.preventDefault()
	})
	.on("ready", function(e){
		
		toggleActiveStyle($(toggleClassName+".active"))

	})


var toggleActiveStyle = function($activeToggle){
	
		var $allToggles = $(toggleClassName),
				on = $activeToggle.data("on"),
				$on = $(on),
				off = $activeToggle.data("off"),
				$off = $(off)
		
		$off.hide()
		
		$on.show()
		
		$allToggles.removeClass("active")
			
		$activeToggle.addClass("active")
	
}
