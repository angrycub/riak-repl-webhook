all: deps compile

compile:
	./rebar compile
	cp ./deps/ibrowse/ebin/ibrowse*.* ./ebin/

deps:
	./rebar get-deps
	
clean:
	./rebar clean