-ifndef(N2O_BOOTSTRAP_HRL).
-define(N2O_BOOTSTRAP_HRL, true).

-include("../../../deps/n2o/include/wf.hrl").

% emulate msg ! socket through wire
-define(WS_SEND(Id,Ev,Detail), wf:wire(wf:f("document.getElementById('~s').dispatchEvent("
  "new CustomEvent('~s', {'detail': ~s}));", [Id,wf:to_list(Ev),wf:json([Detail])]))).

% REST macros
-define(rest(), is_rest() -> true).
-define(unmap(Record), unmap(P,R) -> wf_utils:hunmap(P,R,record_info(fields, Record),size(R)-1)).
-define(map(Record), map(O) ->
    Y = [ try N=lists:nth(1,B), if is_number(N) -> wf:to_binary(B); true -> B end catch _:_ -> B end
          || B <- tl(tuple_to_list(O)) ],
    lists:zip(record_info(fields, Record), Y)).


% Twitter Bootstrap Elements
-record(carousel, {?ELEMENT_BASE(element_carousel), interval=5000, pause= <<"hover">>, start=0, indicators=true, items=[], caption=[]}).
-record(accordion, {?ELEMENT_BASE(element_accordion), items=[], nav_stacked=false}).
-record(slider, {?ELEMENT_BASE(element_slider), min, max, step, orientation, value, selection, tooltip, handle, formater}).

% Synrc Elements
-record(rtable, {?ELEMENT_BASE(element_rtable), rows=[], postback}).
-record(upload_state, {cid, root=code:priv_dir(n2o), dir="", name,
  type, room=upload, data= <<>>, preview=false, size=[{200,200}], index=0, block_size=1048576}).
-record(upload, {?CTRL_BASE(element_upload), name, value, state=#upload_state{}, root, dir, delegate_query, delegate_api, post_write, img_tool, post_target, size, preview}).
-record(textboxlist, {?ELEMENT_BASE(element_textboxlist), placeholder="", postback, unique=true, values=[], autocomplete=true, queryRemote=true, onlyFromValues=true, minLenght=1}).
-record(htmlbox, {?CTRL_BASE(element_htmlbox), html, state=#upload_state{}, root, dir, delegate_query, delegate_api, post_write, img_tool, post_target, size}).

-endif.
