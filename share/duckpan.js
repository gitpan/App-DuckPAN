$(document).ready(function() {

	var $script, name, content;

	DDG.duckpan = true;

	// array of spice template <script>
	var hb_templates = $("script.duckduckhack_spice_template"),
		toCall = [];

	// Check for any spice templates
	// grab their contents and name
	// compile and add named template
	// to global Handlebars obj
	if (hb_templates.length) {
		console.log("Compiling Spice Templates")
		hb_templates.each(function() {
			$script = $(this);
			content = $script.html();
			spiceName = $script.attr("spice-name");
			templateName = $script.attr("template-name");
			if ($script.attr("is-ct-self") === "1"){
				toCall.push(spiceName);
			}

			if (!Spice.hasOwnProperty(spiceName)) {
				Spice[spiceName] = {};
			}

			Spice[spiceName][templateName] = Handlebars.compile(content);

			console.log("Compiled template: ", spiceName+"_"+templateName);
		});

		console.log("Finished compiling templates")
		console.log("Now Spice obj: ", Spice);

		// Need to wait a little for page JS to finish
		// modifying the DOM
		setTimeout(function(){
			$.each(toCall, function(i, name){
				var cbName = "ddg_spice_" + name;
				console.log("Executing: " + cbName);
				window[cbName]();
			});
		}, 100);

		return;
	}
});