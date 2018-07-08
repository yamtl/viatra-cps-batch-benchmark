/*******************************************************************************
 * Copyright (c) 2014-2016 IncQuery Labs Ltd.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     Akos Horvath, Abel Hegedus, Akos Menyhert, Zoltan Ujhelyi - initial API and implementation
 *******************************************************************************/
package org.eclipse.viatra.examples.cps.generator.utils

import java.io.IOException
import java.util.Collections
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.emf.ecore.resource.ResourceSet
import org.eclipse.emf.ecore.resource.impl.BinaryResourceImpl
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.viatra.examples.cps.cyberPhysicalSystem.CyberPhysicalSystem
import org.eclipse.viatra.examples.cps.cyberPhysicalSystem.CyberPhysicalSystemPackage
import org.eclipse.viatra.examples.cps.deployment.Deployment
import org.eclipse.viatra.examples.cps.deployment.DeploymentPackage
import org.eclipse.viatra.examples.cps.traceability.CPS2DeploymentTrace
import org.eclipse.viatra.examples.cps.traceability.TraceabilityPackage
import org.eclipse.emf.ecore.change.ChangeDescription
import org.eclipse.emf.ecore.change.ChangePackage

class PersistenceUtil {
	
	def static saveCPSModelToFile(CyberPhysicalSystem modelRoot, String path){
		// Initialize the model
	    CyberPhysicalSystemPackage.eINSTANCE.eClass();
	    // Retrieve the default factory singleton
	
	    // Obtain a new resource set
	    val ResourceSet resSet = new ResourceSetImpl();
	
	    // create a resource
	    val Resource resource = resSet.createResource(URI.createFileURI(path));
	    resource.getContents().add(modelRoot);
	
	    // now save the content.
	    try {
	      resource.save(Collections.EMPTY_MAP);
	    } catch (IOException e) {
	      e.printStackTrace();
	    }
	}
	
	def static saveCPSModelToFileBinary(CyberPhysicalSystem modelRoot, String path){
		// Initialize the model
	    CyberPhysicalSystemPackage.eINSTANCE.eClass();
	    // Retrieve the default factory singleton
	
	    // create a resource
	    val Resource resource = new BinaryResourceImpl(URI.createFileURI(path));
	    resource.getContents().add(modelRoot);
	
	    // now save the content.
	    try {
		   	resource.save(Collections.EMPTY_MAP);
	    } catch (IOException e) {
	      	e.printStackTrace();
	    }
	}
	
	// Artur
	def static saveDeploymentModelToFile(Deployment modelRoot, String path){
		// Initialize the model
	    DeploymentPackage.eINSTANCE.eClass();
	    // Retrieve the default factory singleton
	
	    // Obtain a new resource set
	    val ResourceSet resSet = new ResourceSetImpl();
	
	    // create a resource
	    val Resource resource = resSet.createResource(URI.createFileURI(path));
	    resource.getContents().add(modelRoot);
	
	    // now save the content.
	    try {
	      resource.save(Collections.EMPTY_MAP);
	    } catch (IOException e) {
	      e.printStackTrace();
	    }
	}
	
	// Artur
	def static saveTraceabilityModelToFile(CPS2DeploymentTrace modelRoot, String path){
		// Initialize the model
	    TraceabilityPackage.eINSTANCE.eClass();
	    // Retrieve the default factory singleton
	
	    // Obtain a new resource set
	    val ResourceSet resSet = new ResourceSetImpl();
	
	    // create a resource
	    val Resource resource = resSet.createResource(URI.createFileURI(path));
	    resource.getContents().add(modelRoot);
	
	    // now save the content.
	    try {
	      resource.save(Collections.EMPTY_MAP);
	    } catch (IOException e) {
	      e.printStackTrace();
	    }
	}

	// Artur
	def static saveChangeDescriptionModelToFile(ChangeDescription des, String path){
		// Initialize the model
	    ChangePackage.eINSTANCE.eClass();
	    // Retrieve the default factory singleton
	
	    // Obtain a new resource set
	    val ResourceSet resSet = new ResourceSetImpl();
	
	    // create a resource
	    val Resource resource = resSet.createResource(URI.createFileURI(path));
	    resource.getContents().add(des);
	
	    // now save the content.
	    try {
	      resource.save(Collections.EMPTY_MAP);
	    } catch (IOException e) {
	      e.printStackTrace();
	    }
	}
	
}