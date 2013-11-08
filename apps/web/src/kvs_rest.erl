-module(kvs_rest).
-compile(export_all).
-include_lib("n2o/include/wf.hrl").
-include_lib("kvs/include/products.hrl").
-include_lib("kvs/include/users.hrl").

?rest().

constructor(Resource) ->
    case Resource of 
         user -> #user{};
         product -> #product{} end.

init()            -> ok.
get(Resource,[])    -> kvs:all(Resource);
get(Resource,Id)    -> kvs:get(Resource,Id).
delete(Resource,Id) -> kvs:remove(Resource,Id).
put(Resource,User)  -> kvs:put(User).
exists(Resource,Id) -> case kvs:get(Resource,Id) of {ok,_} -> true; _ -> false end.
post(Resource,Data) -> kvs:add((wf:to_atom("kvs_"++wf:to_list(Resource))):unmap(Data,constructor(Resource))).
