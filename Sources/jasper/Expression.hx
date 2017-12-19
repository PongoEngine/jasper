/*
 * Haxe Port Copyright (c) 2017 Jeremy Meltingtallow
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the
 * Software, and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN
 * AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH
 * THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

package jasper;

/**
 * Created by alex on 30/01/15.
 */
class Expression {

    private var terms :Array<Term>;

    public var constant :Constant;

    public function new(params :ExpressionParams) : Void
    {
        switch params {
            case None:
                this.constant = new Constant(0);
                this.terms = [];

            case Const(constant):
                this.constant = constant;
                this.terms = [];

            case TermConst(term, constant):
                this.constant = constant;
                this.terms = [term];

            case Term(term):
                this.constant = new Constant(0.0);
                this.terms = [term];

            case TermsConst(terms, constant):
                this.constant = constant;
                this.terms = terms;

            case Terms(terms):
                this.constant = new Constant(0.0);
                this.terms = terms;
        }
    }

    public function getTerms() : Array<Term>
    {
        return terms;
    }

    public function setTerms(terms :Array<Term>) : Void
    {
        this.terms = terms;
    }

    public function getValue() : Value
    {
        var result = this.constant;

        for (term in terms) {
            result += term.getValue();
        }
        return result.toValue();
    }

    public function isConstant() : Bool
    {
        return terms.length == 0;
    }

    public function toString() : String
    {
        var sb = "isConstant: " + isConstant() + " constant: " + constant;

        if (!isConstant()) {
            sb += " terms: [";
            for (term in terms) {
                sb += "(";
                sb += term;
                sb += ")";
            }
            sb += "] ";
        }
        return sb;
    }

}

enum ExpressionParams
{
    None;
    Const(constant :Constant);
    TermConst(term :Term, constant :Constant);
    Term(term :Term);
    TermsConst(terms :Array<Term>, constant :Constant);
    Terms(terms :Array<Term>);
}