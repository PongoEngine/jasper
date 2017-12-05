// Copyright (C) 1998-2000 Greg J. Badros
// Use of this source code is governed by http://www.apache.org/licenses/LICENSE-2.0
//
// Parts Copyright (C) 2011, Alex Russell (slightlyoff@chromium.org)

(function(c) {
"use strict";

c.Tableau = c.inherit({
  initialize: function() {
    // columns is a mapping from variables which occur in expressions to the
    // set of basic variables whose expressions contain them
    // i.e., it's a mapping from variables in expressions (a column) to the
    // set of rows that contain them
    this.columns = new c.HashTable(); // values are sets

    // _rows maps basic variables to the expressions for that row in the tableau
    this.rows = new c.HashTable();    // values are c.Expressions

    // the collection of basic variables that have infeasible rows
    // (used when reoptimizing)
    this._infeasibleRows = new c.HashSet();

    // the set of rows where the basic variable is external this was added to
    // the C++ version to reduce time in setExternalVariables()
    this._externalRows = new c.HashTable();
  },

  // Variable v has been removed from an Expression.  If the Expression is in a
  // tableau the corresponding basic variable is subject (or if subject is nil
  // then it's in the objective function). Update the column cross-indices.
  noteRemovedVariable: function(v /*c.AbstractVariable*/,
                                subject /*c.AbstractVariable*/) {
    var column = this.columns.get(v);
    if (subject && column) {
      column.delete(subject);
    }
  },

  noteAddedVariable: function(v /*c.AbstractVariable*/, subject /*c.AbstractVariable*/) {
    if (subject) {
      this.insertColVar(v, subject);
    }
  },

  getInternalInfo: function() {
    return "Tableau Information:\n" +
           "Rows: " + this.rows.size +
            " (= " + (this.rows.size - 1) + " constraints)" +
            "\nColumns: " + this.columns.size +
            "\nInfeasible Rows: " + this._infeasibleRows.size +
            "\nExternal basic variables: " + this._externalRows.size;
  },

  toString: function() {
    var str = "Tableau:\n";
    this.rows.each(function(clv, expr) {
      str += clv + " <==> " + expr + "\n";
    });
    str += "\nColumns:\n";
    str += this.columns;
    str += "\nInfeasible rows: ";
    str += this._infeasibleRows;
    str += "External basic variables: ";
    str += this._externalRows;
    return str;
  },

  /*
  toJSON: function() {
    // Creates an object representation of the Tableau.
  },
  */

  // Convenience function to insert a variable into
  // the set of rows stored at columns[param_var],
  // creating a new set if needed
  insertColVar: function(param_var /*c.Variable*/,
                         rowvar /*c.Variable*/) {
    var rowset = /* Set */ this.columns.get(param_var);
    if (!rowset) {
      rowset = new c.HashSet();
      this.columns.set(param_var, rowset);
    }
    rowset.add(rowvar);
  },

  addRow: function(aVar /*c.AbstractVariable*/,
                   expr /*c.Expression*/) {
    this.rows.set(aVar, expr);
    expr.terms.each(function(clv, coeff) {
      this.insertColVar(clv, aVar);
    }, this);
    if (aVar.isExternal) {
      // console.log("addRow(): aVar is external:", aVar.name, aVar.hashCode);
      this._externalRows.set(aVar, expr);
      // this._updatedExternals.add(aVar);
    }
  },

  removeColumn: function(aVar /*c.AbstractVariable*/) {
    var rows = /* Set */ this.columns.get(aVar);
    if (rows !== null) {
      this.columns.delete(aVar);
      rows.each(function(clv) {
        var expr = /* c.Expression */this.rows.get(clv);
        expr.terms.delete(aVar);
      }, this);
    /*
    } else {
      // console.log("Could not find var", aVar, "in columns");
    */
    }
    if (aVar.isExternal) {
      this._externalRows.delete(aVar);
    }
  },

  removeRow: function(aVar /*c.AbstractVariable*/) {
    var expr = /* c.Expression */this.rows.get(aVar);
    c.assert(expr != null);
    expr.terms.each(function(clv, coeff) {
      var varset = this.columns.get(clv);
      if (varset != null) {
        varset.delete(aVar);
      }
    }, this);
    this._infeasibleRows.delete(aVar);
    if (aVar.isExternal) {
      this._externalRows.delete(aVar);
    }
    this.rows.delete(aVar);
    return expr;
  },

  substituteOut: function(oldVar /*c.AbstractVariable*/,
                          expr /*c.Expression*/) {
    var varset = this.columns.get(oldVar);
    varset.each(function(v) {
      var row = this.rows.get(v);
      row.substituteOut(oldVar, expr, v, this);
      if (v.isExternal) {
        this._updatedExternals.add(v);
      }
      if (v.isRestricted && row.constant < 0) {
        this._infeasibleRows.add(v);
      }
    }, this);

    if (oldVar.isExternal) {
      this._externalRows.set(oldVar, expr);
    }

    this.columns.delete(oldVar);
  },

  columnsHasKey: function(subject /*c.AbstractVariable*/) {
    return !!this.columns.get(subject);
  },
});

})(this["c"]||module.parent.exports||{});
