/**
 * Copyright (c) 2014-2016 IncQuery Labs Ltd.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 * 
 * Contributors:
 *     Akos Horvath, Abel Hegedus, Tamas Borbas, Zoltan Ujhelyi, Istvan David - initial API and implementation
 */
package org.eclipse.viatra.examples.cps.deployment;

import org.eclipse.emf.common.util.EList;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Host</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link org.eclipse.viatra.examples.cps.deployment.DeploymentHost#getApplications <em>Applications</em>}</li>
 *   <li>{@link org.eclipse.viatra.examples.cps.deployment.DeploymentHost#getIp <em>Ip</em>}</li>
 * </ul>
 *
 * @see org.eclipse.viatra.examples.cps.deployment.DeploymentPackage#getDeploymentHost()
 * @model
 * @generated
 */
public interface DeploymentHost extends DeploymentElement {
	/**
	 * Returns the value of the '<em><b>Applications</b></em>' containment reference list.
	 * The list contents are of type {@link org.eclipse.viatra.examples.cps.deployment.DeploymentApplication}.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Applications</em>' containment reference list isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Applications</em>' containment reference list.
	 * @see org.eclipse.viatra.examples.cps.deployment.DeploymentPackage#getDeploymentHost_Applications()
	 * @model containment="true"
	 * @generated
	 */
	EList<DeploymentApplication> getApplications();

	/**
	 * Returns the value of the '<em><b>Ip</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Ip</em>' attribute isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Ip</em>' attribute.
	 * @see #setIp(String)
	 * @see org.eclipse.viatra.examples.cps.deployment.DeploymentPackage#getDeploymentHost_Ip()
	 * @model id="true"
	 * @generated
	 */
	String getIp();

	/**
	 * Sets the value of the '{@link org.eclipse.viatra.examples.cps.deployment.DeploymentHost#getIp <em>Ip</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Ip</em>' attribute.
	 * @see #getIp()
	 * @generated
	 */
	void setIp(String value);

} // DeploymentHost
