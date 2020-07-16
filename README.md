# Definitions of trust messages in ASN.1

This project contains definitions of trust messages in ASN.1 format and the grammar for constructing queries from string statements. To compile bindings for Java or Python, follow instructions below.

However, all these steps have already been taken in two example project:

*   Python Trust Messages, and
*   Java Trust Messages.

See README files of those two projects for more information.


## Python ASN.1 messages

To compile ASN.1 specs in python classes (source file `messages.asn`, destination file `messages.py`), you need two libraries:

*   [asn1ate -- Python ASN.1 compiler.](https://github.com/kimgr/asn1ate) for translating ASN.1 specs into Python code;
*   [PyASN.1 -- Python library for ASN.1](http://pyasn1.sourceforge.net) for using compiled classes.

Once you install those two libraries, run the following:

```sh
python [path-to-asn1ate-lib]/pyasn1gen.py messages.asn > messages.py
```

In my case (it will likely be different on your machine):

```sh
python /home/david/Development/python/virtualenvs/trust-messages/lib/python3.5/site-packages/asn1ate/pyasn1gen.py messages.asn > ~/Development/trust-messages/py-trustmessages/trustmessages/messages.py
```

Then modify the generated `messages.py` by adding the `Logical` and `Query` commands into a loop; this is a trick to make PyASN.1 work with recursive data-types.

```py
for _ in range(10):
    Expression.tagSet = univ.Sequence.tagSet.tagImplicitly(tag.Tag(tag.tagClassApplication, tag.tagFormatConstructed, 6))
    Expression.componentType = namedtype.NamedTypes(
        namedtype.NamedType('operator', univ.Enumerated(namedValues=namedval.NamedValues(('and', 0), ('or', 1)))),
        namedtype.NamedType('left', Query()),
        namedtype.NamedType('right', Query())
    )
    Query.componentType = namedtype.NamedTypes(
        namedtype.NamedType('con', Constraint()),
        namedtype.NamedType('exp', Expression())
)
```

## Java ASN.1 messages

Java classes can be generated with [OpenMUC jasn1-compiler.](https://www.openmuc.org/asn1/download)
Once installed, run it against the messages file:

*   Core messages: `./jasn1-compiler -l -o "generated" -p "trustmessages.asn" -f ~/Development/trust-messages/asn1-trustmessages/messages.asn`
*   Sample trust formats: `./jasn1-compiler -p "trustmessages.asn" -f ~/Development/trust-messages/asn1-trustmessages/formats.asn`

## Grammar for parsing query statements: Java lexer and parser

You need to have [ANTLR 4](http://www.antlr.org) installed. Follow the installation instructions on their homepage. But in short (could be outdated):

*   Download the ANTLR: `cd /usr/local/lib && sudo curl -O http://www.antlr.org/download/antlr-4.6-complete.jar`
*   Put the following aliases into ~/.bashrc and restart your shell
  ```sh
  alias antlr4='java -jar /usr/local/lib/antlr-4.6-complete.jar'
  alias grun="java -cp .:/usr/local/lib/antlr-4.6-complete.jar org.antlr.v4.gui.TestRig"
  alias gcomp="javac -cp /usr/local/lib/antlr-4.6-complete.jar $*"
  alias gexec="java -cp .:/usr/local/lib/antlr-4.6-complete.jar $*"
  ```

Generate the lexer and parser.

```sh
# Generate parser and lexer
antlr4 Query.g4 -no-listener -visitor

# Compile generate Java classes either with
javac -cp /usr/local/lib/antlr-4.6-complete.jar *.java

# or using an alias: alias gcomp="javac -cp /usr/local/lib/antlr-4.6-complete.jar $*"
gcomp *.java
```

Test the grammar

```sh
# Check generated tokens
grun Query expr -tokens

# Check generated parse tree in LISP notation
grun Query expr -tree

# Check generated parse tree with a GUI
grun Query expr -gui
```

## Grammar for parsing query statements: Python lexer and parser

You need [ANTLR v4.](http://www.antlr.org)

```sh
# Generate parser, lexer and a default visitor implementation
antlr4 Query.g4 -no-listener -visitor -Dlanguage=Python2
```
