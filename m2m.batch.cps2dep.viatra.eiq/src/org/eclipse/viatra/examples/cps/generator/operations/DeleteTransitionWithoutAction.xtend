/*******************************************************************************
 * Copyright (c) 2014-2016 IncQuery Labs Ltd.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     Akos Horvath, Abel Hegedus, Akos Menyhert, Zoltan Ujhelyi - initial API and implementation
 * 	   Artur Boronat - minor tweak to use TransitionWithoutActionMatcher
 *******************************************************************************/
package org.eclipse.viatra.examples.cps.generator.operations

import org.eclipse.viatra.examples.cps.generator.dtos.CPSFragment
import org.eclipse.viatra.examples.cps.planexecutor.api.IOperation
import org.eclipse.viatra.examples.cps.generator.queries.TransitionWithoutActionMatcher
import org.eclipse.emf.ecore.util.EcoreUtil

class DeleteTransitionWithoutAction implements IOperation<CPSFragment> {
	
	CPSFragment fragment
	
	new(CPSFragment fragment){
		this.fragment = fragment;
	}
	
	override execute(CPSFragment fragment) {
		
		val matcher = TransitionWithoutActionMatcher.on(fragment.engine)
		
		matcher.allMatches.forEach[
			EcoreUtil.delete(it.t)
		]
		
		true;
	}
	
}