# Definitions of trust messages in ASN.1

This project contains definitions of trust messages and the grammar for constructing them. To compile bindings for
Java or Python, follow instructions below.

## Python ASN.1 messages

The messages can be generated using [asn1ate -- ASN.1 translation library.](https://github.com/kimgr/asn1ate)
and the [ASN.1 library for Python.](http://pyasn1.sourceforge.net)

To compile ASN.1 specs from file `messages.asn` into python classes in file
`messages.py`, run the following:

```sh
python /home/david/Development/python/virtualenvs/trust-messages/lib/python3.5/site-packages/asn1ate/pyasn1gen.py messages.asn > ~/Development/trust-messages/py-trustmessages/trustmessages/messages.py
```
Then modify the generated `messages.py` by adding the `Logical` and `Query` commands into a loop:

```py
for _ in range(10):
    Logical.tagSet = univ.Sequence.tagSet.tagImplicitly(tag.Tag(tag.tagClassApplication, tag.tagFormatConstructed, 5))
    Logical.componentType = namedtype.NamedTypes(
        namedtype.NamedType('op', univ.Enumerated(namedValues=namedval.NamedValues(('and', 0), ('or', 1)))),
        namedtype.NamedType('l', Query()),
        namedtype.NamedType('r', Query())
    )
    Query.componentType = namedtype.NamedTypes(
        namedtype.NamedType('cmp', Comparison()),
        namedtype.NamedType('log', Logical())
    )
```

## Java ASN.1 messages

The messages can be generated with [OpenMUC jasn1-compiler.](https://www.openmuc.org/asn1/download)
Once installed, run it against the messages file:

*   Core messages: `./jasn1-compiler -l -o "generated" -p "trustmessages.asn" -f ~/Development/trust-messages/asn1-trustmessages/messages.asn`
*   Sample trust formats: `./jasn1-compiler -p "trustmessages.asn" -f ~/Development/trust-messages/asn1-trustmessages/formats.asn`

## Query language: Python lexer and parser

Todo.

## Query language: Java lexer and parser

You need the ANTLR v4.

```sh
# Generate parser and lexer
antlr4 Query.g4 -no-listener -visitor

# Compile generate Java classes either with
javac -cp /usr/local/lib/antlr-4.6-complete.jar *.java
# or using an alias: alias gcomp="javac -cp /usr/local/lib/antlr-4.6-complete.jar $*"
gcomp *.java

# Test the grammar:
#  Check generated tokens
grun Query expr -tokens

#  Check generated parse tree in LISP notation
grun Query expr -tree

#  Check generated parse tree with a GUI
grun Query expr -gui
```