var sortClassName = ".sort-results-select"

$(document)
	.on("change", sortClassName, function(e){
		
		var $select = $(this)
		
		navigateSelected($select[0])
		
	})


var navigateSelected = function(select){
		
		var selected = select.options[select.selectedIndex].value
		
		window.location = selected
	
}
