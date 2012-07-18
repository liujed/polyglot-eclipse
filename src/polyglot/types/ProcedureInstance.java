/*******************************************************************************
 * This file is part of the Polyglot extensible compiler framework.
 *
 * Copyright (c) 2000-2008 Polyglot project group, Cornell University
 * Copyright (c) 2006-2008 IBM Corporation
 * All rights reserved.
 *
 * This program and the accompanying materials are made available under
 * the terms of the Eclipse Public License v1.0 which accompanies this
 * distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * This program and the accompanying materials are made available under
 * the terms of the Lesser GNU Public License v2.0 which accompanies this
 * distribution.
 * 
 * The development of the Polyglot project has been supported by a
 * number of funding sources, including DARPA Contract F30602-99-1-0533,
 * monitored by USAF Rome Laboratory, ONR Grant N00014-01-1-0968, NSF
 * Grants CNS-0208642, CNS-0430161, and CCF-0133302, an Alfred P. Sloan
 * Research Fellowship, and an Intel Research Ph.D. Fellowship.
 *
 * See README for contributors.
 ******************************************************************************/

package polyglot.types;

import java.util.List;

/**
 * A <code>ProcedureInstance</code> contains the type information for a Java
 * procedure (either a method or a constructor).
 */
public interface ProcedureInstance extends CodeInstance
{
    /**
     * List of formal parameter types.
     * @return A list of <code>Type</code>.
     * @see polyglot.types.Type
     */
    List<? extends Type> formalTypes();
    void setFormalTypes(List<? extends Type> l);
    
    /**
     * List of declared exception types thrown.
     * @return A list of <code>Type</code>.
     * @see polyglot.types.Type
     */
    List<? extends Type> throwTypes();
    void setThrowTypes(List<? extends Type> l);
    
    /**
     * Returns a String representing the signature of the procedure.
     * This includes just the name of the method (or name of the class, if
     * it is a constructor), and the argument types.
     */
    String signature();

    /**
     * String describing the kind of procedure, (e.g., "method" or "constructor").
     */
    String designator();

    /**
     * Return true if <code>this</code> is more specific than <code>pi</code>
     * in terms of method overloading.
     */
    boolean moreSpecific(ProcedureInstance pi);

    /**
     * Returns true if the procedure has the given arguments.
     */
    boolean hasFormals(List<? extends Type> arguments);

    /**
     * Returns true if the procedure throws a subset of the exceptions
     * thrown by <code>pi</code>.
     */
    boolean throwsSubset(ProcedureInstance pi);

    /**
     * Returns true if the procedure can be called with the given arguments.
     */
    boolean callValid(List<? extends Type> actualTypes);

    /**
     * Return true if <code>this</code> is more specific than <code>pi</code>
     * in terms of method overloading.
     */
    boolean moreSpecificImpl(ProcedureInstance pi);

    /**
     * Returns true if the procedure has the given arguments.
     */
    boolean hasFormalsImpl(List<? extends Type> arguments);

    /**
     * Returns true if the procedure throws a subset of the exceptions
     * thrown by <code>pi</code>.
     */
    boolean throwsSubsetImpl(ProcedureInstance pi);

    /**
     * Returns true if the procedure can be called with the given arguments.
     */
    boolean callValidImpl(List<? extends Type> actualTypes);
}
