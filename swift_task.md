Brute forcer
============

Write a (Swift) macOS (or iOS, if that's your preference) program
for bruteforcing HTTP Basic Auth.

The app should provide a GUI that allows user to set:

- `wordlist`: a text file containing "word" dictionary, one word
  per line
- `alphabet`: a text file containing substitution alphabet (with
  each line listing equivalent characters)
- `url`: an URL being target for brute forcing

Example wordlist:

```
hi
there
```

Example alphabet:

```
i1
o0O
```

Once user provides all the necessery inputs, he should be able to
start the operation, which in turn performs actions as described
below.


Credentials generation
----------------------

Program generates credentials by applying each word from the
wordlist as `user` and `password`.

For every letter in a word, program should generate and use for
authentication all the variants applying the letters available in
alphabet.

For alphabet example given above, word `hi` would have variants:
`hi`, `h1`.


Bruteforce operation
--------------------

For each generated credentials program should attempt to
authenticate with the URL given as argument. In case of
successful authentication program outputs valid credentials and
terminates.

Other remarks
-------------

1. Program will be tested on multi core system with standard
   amounts of available memory. You should pay attention to use
   hardware resources as available.
2. This task is to let us understand what's the style and quality
   of the code you professionaly deliver, so please treat this as
   opportunity to show us those aspects of your work. Ideally
   your solution should be close to what you would normally
   deliver to your customer and be documented well enough to let
   other developers understand the architecture of your software.
3. You may assume that there is no protection (i.e. firewall,
   proxy) between the device your program is running on and the
   target server that will permanently block your app. You should
   however be prepared that target server may be limited in
   capacity of requests it is able to simultanously handle.
4. It is OK to make your own, common sense assumptions for the
   that do not conflict with above description, however if you
   make some assumption that impacts the solution, be sure to
   describe it in README.txt with short explaination (what you
   assume, why you think the assumption is needed, how does it
   impact your solution).
