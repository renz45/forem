// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(document).ready(function() {
    
  breadcrumbs = {
    toggle_remove_category : function(submit_button){
      btn = $(submit_button);
      if(btn.val() == 'remove'){
        btn.val(breadcrumbs.category);
        btn.width('auto');
      }else{
        breadcrumbs.category = btn.val();
        btn.width(btn.outerWidth());
        btn.val('remove');
      }
    }//end toggle_remove_category
  }//end breadcrumbs

  //bindings

  //auto submit on selection
  $('.forem-breadcrumb-form select').change(function(){
    $(this).parent().trigger('submit');
  });

  //remove category hover state
  $('.edit-breadcrumbs-for-category')
  .delegate('.forem-remove-category input[type=submit]', 'mouseover', function(){
    breadcrumbs.toggle_remove_category(this);
  })
  .delegate('.forem-remove-category input[type=submit]', 'mouseout', function(){
    breadcrumbs.toggle_remove_category(this);
  })

});
