$(document)
	.on("click", "tr", function(e){
		
		var $row = $(this),
				$link = $row.find("a[href]").first()
		
		if ($link.attr("href").length > 5){
			window.location = $link.attr("href")
		}
		
		e.preventDefault()
	})
