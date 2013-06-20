-module (element_tinymce).
-compile(export_all).
-include_lib("n2o/include/wf.hrl").
-include("records.hrl").

render_element(R = #tinymce{}) ->
  Id = case R#tinymce.id of undefined -> wf:temp_id(); I -> I end,
  SavePostback = wf_event:generate_postback_script(ok, R#tinymce.anchor, Id, undefined, control_event, [<<"{'mcecontent': s1}">>]),

  S = wf:f("$(function(){"++
    "$('~s').tinymce({" ++
      "script_url: '~s',"++
      "theme: '~s'," ++
      "plugins: "++
        "'ksave advlist autolink lists link image charmap preview hr anchor pagebreak "++
        "searchreplace wordcount visualblocks visualchars code fullscreen "++
        "insertdatetime media nonbreaking table contextmenu directionality "++
        "emoticons template paste layer'"++
      "," ++
      "toolbar1:" ++
        "'ksave cleanup | insertfile undo redo | styleselect | bold italic "++
        "| alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | link image media "++
        "| preview fullscreen code'" ++
      ","++
      "setup: function(ed){" ++
        "$(ed).unbind('SaveContent');
        ed.on('SaveContent', function(event){
          var s1 = $.trim(ed.getContent().replace(/[\\s\\n\\r]+/g, ' '));
          ~s;
        });"++
        "$('.tinymce').html('~s');"++
      "}" ++
    "});"++
  "});", ["#"++Id, R#tinymce.script_url, R#tinymce.theme, SavePostback, R#tinymce.html]),

  wf:wire(S),
  wf_tags:emit_tag(<<"div">>, [], [{id, Id}, {class, tinymce}]).
