/*
 * Copyright (c) 2013-2017, Nucleic Development Team.
 * Haxe Port Copyright (c) 2017 Jeremy Meltingtallow
 *
 * Distributed under the terms of the Modified BSD License.
 *  
 *  The full license is in the file COPYING.txt, distributed with this software.
*/

package jasper;

import jasper.Symbolics.Expression;
import jasper.Symbolics.Term;

class _Expression_
{
    public var m_terms (default, null):List<Term>;
    public var m_constant (default, null):Float;

    /**
     *  [Description]
     *  @param terms - 
     *  @param constant - 
     */
    public function new(terms :List<Term>, constant :Float) : Void
    {
        this.m_terms = terms;
        this.m_constant = constant;
    }

    /**
     *  [Description]
     *  @param constant - 
     *  @return Expression
     */
    public static inline function fromConstant(constant :Float) : Expression
    {
        return new Expression(new List<Term>(), constant);
    }

    /**
     *  [Description]
     *  @param term - 
     *  @param constant - 
     *  @return Expression
     */
    public static inline function fromTermAndConstant(term :Term, constant :Float) : Expression
    {
        var terms = new List<Term>();
        terms.add(term);
        return new Expression(terms, constant);
    }

    /**
     *  [Description]
     *  @param term - 
     *  @return Expression
     */
    public static inline function fromTerm(term :Term) : Expression
    {
        return fromTermAndConstant(term, 0.0);
    }

    /**
     *  [Description]
     *  @param terms - 
     *  @return Expression
     */
    public static inline function fromTerms(terms :List<Term>) : Expression
    {
        return new Expression(terms, 0.0);
    }

    /**
     *  [Description]
     *  @return Float
     */
    public function value() : Float
    {
		var result = m_constant;
		for(term in m_terms)
			result += term.getValue();
		return result;
    }
}

