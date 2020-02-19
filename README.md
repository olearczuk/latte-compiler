# Overview
Programs are compiled into x86 assembly code.
Language grammar is presented in *src/Grannar/Latte.cf* file. Using this grammar I was able to use [BNF Converter](https://bnfc.digitalgrammars.com/). Code samples can be found in **tests** directory.
## Language description
Latte is objective language modelled after Java language. It is statically typed.
## Types
| **Type** | **Default value**  |
|----------|:------------------:|
| void     | **Does not exist** |
| int      | 0                  |
| string   | ""                 |
| bool     | false              |

## Operators
- Arithmetic operators: `+, -, *, /, %`
- Relational operators: `<, <=, >, >=, ==, !=`
- Logical operators: `&&, ||, !`

## Comments
Multi-line comments using `/* */`, one-line comments using `//`

## Instructions
### IO instructions
#### Prints
```python
printInt(EXP_INT);
printString(EXP_STR);
```
#### Reads
```python
int IDENT = readInt();
string IDENT = readString();
```
### Loops
#### While
```python
while (CONDITION) {
  INSTRUCTIONS
}
```
#### For
EXPR1 and EXPR2 are evaluated before executing loop. Variable is read-only, attempt of changing variable inside of the loop causes compile error.
```python
for (IDENT = EXPR1, EXPR2) {
  INSTRUCTIONS
}
```
#### Break and continue
Break and continue act exactly like in C. They work in both types of loops.

### Conditional statements
```python
if (CONDITION) {
  INSTRUCTIONS
}

if (CONDITION) {
  INSTRUCTIONS
} else {
  INSTRUCTIONS
}
```
## OOP
Latte supports OOP with single inheritance (all methods are virtual by definition).