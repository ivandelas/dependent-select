(function($){
  /*
   * Sets up a select that refreshes its options whenever another
   * field changes value.
   *
   * parentId - the ID of the observed field
   *
   * urlTemplate - the URL used to request the new data from the
   *               server.  The value of the parent field will be
   *               substituted for ${value} in the template
   *
   */
  $.fn.dependentSelect = function(parentId, urlTemplate, options) {
    options = $.extend({
      optionTemplate: '<option value="{{id}}">{{name}}</option>',
      blankOptionHtml: '<option value=""></option>'
    }, options || {});

    var select = this;
    
    $('#' + parentId).bind('change', function(event, callback) {
      select.empty().append(Mustache.render(options.blankOptionHtml)); // clear out the current options

      var url = Mustache.render(urlTemplate, {value: event.target.value});

      $.getJSON(url, function(resources) {
        var nodes = [ ];

        if (options.includeBlank) {
          nodes.push(options.blankOptionHtml);
        }

        for (var i = 0; i < resources.length; i++) {
          // substitute resource property values in optionTemplate
          var optionNode = Mustache.render(options.optionTemplate, resources[i]);

          nodes.push(optionNode);
        }
        select.empty().append(nodes.join(''));

        if(typeof callback !== 'undefined'){
          callback();
        }
      });
    });

    return this;
  };
})(jQuery);
