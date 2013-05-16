%% Riak Repl replication hook for calling a REST resource with a GET request.
 
-module(riak_repl_webhook).
-export([register/0]).
-export([recv/1, call_webhook/2, send/2, send_realtime/2]).

register() ->
	case lists:member({enabled, true}, app_helper:get_env(riak_repl, riak_repl_webhook)) of
		true ->
			lager:log(info,self(),"Automatically registering ~p hook with riak_core",[?MODULE_STRING]),

			application:start(ibrowse),

			riak_core:register([{repl_helper, ?MODULE}]),
			case lists:member({undefined,?MODULE}, app_helper:get_env(riak_core,repl_helper, [])) of
				true ->
					lager:log(info,self(),"Successfully registered ~p hook with riak_core",[?MODULE_STRING]);
				false ->
					lager:log(info,self(),"Failed to register ~p hook with riak_core",[?MODULE_STRING])
			end,
			ok;
		false ->
			ok;
		undefined ->
			ok
	end,
	ok.
 
recv(Object) ->
	% This is a BLOCKING function, so the blocking HTTP request is spun off into its own process.
	Pid = spawn(?MODULE, call_webhook, [Object, self()]),
	ok.
	
send_realtime(_Object, _RiakClient) -> 
	ok.
 
send(_Object, _RiakClient) ->  
	ok.

call_webhook(Object, Caller) ->
	Url = proplists:get_value(url, app_helper:get_env(riak_repl, riak_repl_webhook)) ++ riak_object:key(Object),
	case ibrowse:send_req(Url, [], get) of
		{ok, Status, Headers, Body} ->
			ok;
		{error, Reason} ->
			lager:log(info,Caller,"Failed riak_repl_webhook call to (~p) for Reason: ~p",[Url, Reason]),
			ok
	end,
	ok.


