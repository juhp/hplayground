Playground
==========
Create applications in the browser as fast as easy as console applications and have reactive, window-oriented
and spreadsheet-like behaviours for free.

So you translate your inputs and outputs from console calls to playground widgets and with no more modifications
you have reactive and spreadsheet behaviours.

Hplayground is the MFlow widgets running in the browser with the Haste compiler

This program creates two input boxes and present the sum below them:


        import Haste.HPlay.View
        import Control.Applicative


        main= runBody action

        action :: Widget ()
        action = do
             r  <- (+) <$> inputInt Nothing `wake` OnKeyPress <++ br
                       <*> inputInt Nothing `wake` OnKeyPress <++ br
             p  (show r) ++> noWidget

Each widget creates his own rendering and manage his own events, that can be propagated
or not down trough the monadic computation and trigger modifications in the DOM.

An online example is here, with some explanations:

http://mflowdemo.herokuapp.com/noscript/wiki/browserwidgets

Additionally you can see a more complex example: the [hplay-todo](https://github.com/agocorona/hplay-todo),
 the [todoMVC]/http://todomvc.com) project for hplayground.

The [todo application running](http://mflowdemo.herokuapp.com/todo.html)

The source of the last version of this example is in the file Main.hs:

https://github.com/agocorona/playground/blob/master/src/Main.hs

How it works
============
Under the hood there is the good old formlet concept. It uses monadic and applicative combinators
The same ones used by MFlow in the server side. While the server side widgets of MFlow
produce blaze-html output converted to bytestrings, playground construct a builder function that
creates a tree in the HTML DOM when executed. This builder (perch) is monoidal so the formlet
can aggregate subtrees. When some event happens in the widget subtree, the widget executes
his code and reconstruct itself. If it return a valid result and it is in a monadic computation
the tree continues recreating itself downstream by executing further widgets in the monadic sequence.
If the event is raised within a widget that does not generate a valid result (return empty)
the remaining widgets continue unchanged and unevaluated.

Status
====== 

Non-local modifications of the DOM works with the new "at" primitive.
Option buttons, checkboxes and drop-down buttons works with the same syntax than MFlow.

The Cell module has Lens-like primitives for updates of form elements and experimental math
operations with form elements as spreadsheet cells. Currently it is at the beginning.

How to run
----------

install the [ghc compiler](http://www.haskell.org/platform/)

install Haste:

    >cabal install haste-compiler

install perch

    >haste-inst install haste-perch

clone hplayground
  
    >git clone http://github.com/agocorona/hplayground


install hplayground:

    >haste-inst install
    
compile

    >cd src
    >hastec Main.hs --output-html

hastec uses ghc internally so you can expect ordinary ghc error messages in your development.    

Browse the Main.html file. In windows simply execute it in the command line:

    >Main.html
    
you can also see it executing at 

     http://mflowdemo.herokuapp.com/noscript/wiki/browserwidgets

Main.html and Main.js is included in the repo so you can execute it in your PC

Execute it in the same directory where Main.js is, since it references it assuming that it is in the current folder

