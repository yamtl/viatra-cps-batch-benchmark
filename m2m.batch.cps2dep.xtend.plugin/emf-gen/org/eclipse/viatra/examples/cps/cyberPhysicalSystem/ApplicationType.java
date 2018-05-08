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
package org.eclipse.viatra.examples.cps.cyberPhysicalSystem;

import org.eclipse.emf.common.util.EList;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Application Type</b></em>'.
 * <!-- end-user-doc -->
 *
 * <!-- begin-model-doc -->
 * A descriptor for a class of applications.
 * <!-- end-model-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link org.eclipse.viatra.examples.cps.cyberPhysicalSystem.ApplicationType#getExeFileLocation <em>Exe File Location</em>}</li>
 *   <li>{@link org.eclipse.viatra.examples.cps.cyberPhysicalSystem.ApplicationType#getExeType <em>Exe Type</em>}</li>
 *   <li>{@link org.eclipse.viatra.examples.cps.cyberPhysicalSystem.ApplicationType#getZipFileUrl <em>Zip File Url</em>}</li>
 *   <li>{@link org.eclipse.viatra.examples.cps.cyberPhysicalSystem.ApplicationType#getRequirements <em>Requirements</em>}</li>
 *   <li>{@link org.eclipse.viatra.examples.cps.cyberPhysicalSystem.ApplicationType#getCps <em>Cps</em>}</li>
 *   <li>{@link org.eclipse.viatra.examples.cps.cyberPhysicalSystem.ApplicationType#getInstances <em>Instances</em>}</li>
 *   <li>{@link org.eclipse.viatra.examples.cps.cyberPhysicalSystem.ApplicationType#getBehavior <em>Behavior</em>}</li>
 *   <li>{@link org.eclipse.viatra.examples.cps.cyberPhysicalSystem.ApplicationType#getExeFileSize <em>Exe File Size</em>}</li>
 * </ul>
 *
 * @see org.eclipse.viatra.examples.cps.cyberPhysicalSystem.CyberPhysicalSystemPackage#getApplicationType()
 * @model
 * @generated
 */
public interface ApplicationType extends Identifiable {
	/**
	 * Returns the value of the '<em><b>Exe File Location</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * <!-- begin-model-doc -->
	 * Where to look for the executable file.
	 * <!-- end-model-doc -->
	 * @return the value of the '<em>Exe File Location</em>' attribute.
	 * @see #setExeFileLocation(String)
	 * @see org.eclipse.viatra.examples.cps.cyberPhysicalSystem.CyberPhysicalSystemPackage#getApplicationType_ExeFileLocation()
	 * @model
	 * @generated
	 */
	String getExeFileLocation();

	/**
	 * Sets the value of the '{@link org.eclipse.viatra.examples.cps.cyberPhysicalSystem.ApplicationType#getExeFileLocation <em>Exe File Location</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Exe File Location</em>' attribute.
	 * @see #getExeFileLocation()
	 * @generated
	 */
	void setExeFileLocation(String value);

	/**
	 * Returns the value of the '<em><b>Exe Type</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * <!-- begin-model-doc -->
	 * The type of the executable file.
	 * <!-- end-model-doc -->
	 * @return the value of the '<em>Exe Type</em>' attribute.
	 * @see #setExeType(String)
	 * @see org.eclipse.viatra.examples.cps.cyberPhysicalSystem.CyberPhysicalSystemPackage#getApplicationType_ExeType()
	 * @model
	 * @generated
	 */
	String getExeType();

	/**
	 * Sets the value of the '{@link org.eclipse.viatra.examples.cps.cyberPhysicalSystem.ApplicationType#getExeType <em>Exe Type</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Exe Type</em>' attribute.
	 * @see #getExeType()
	 * @generated
	 */
	void setExeType(String value);

	/**
	 * Returns the value of the '<em><b>Zip File Url</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Zip File Url</em>' attribute isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Zip File Url</em>' attribute.
	 * @see #setZipFileUrl(String)
	 * @see org.eclipse.viatra.examples.cps.cyberPhysicalSystem.CyberPhysicalSystemPackage#getApplicationType_ZipFileUrl()
	 * @model
	 * @generated
	 */
	String getZipFileUrl();

	/**
	 * Sets the value of the '{@link org.eclipse.viatra.examples.cps.cyberPhysicalSystem.ApplicationType#getZipFileUrl <em>Zip File Url</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Zip File Url</em>' attribute.
	 * @see #getZipFileUrl()
	 * @generated
	 */
	void setZipFileUrl(String value);

	/**
	 * Returns the value of the '<em><b>Requirements</b></em>' containment reference list.
	 * The list contents are of type {@link org.eclipse.viatra.examples.cps.cyberPhysicalSystem.ResourceRequirement}.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * <!-- begin-model-doc -->
	 * The resource requirements of the application are stored in this reference.
	 * <!-- end-model-doc -->
	 * @return the value of the '<em>Requirements</em>' containment reference list.
	 * @see org.eclipse.viatra.examples.cps.cyberPhysicalSystem.CyberPhysicalSystemPackage#getApplicationType_Requirements()
	 * @model containment="true" resolveProxies="true"
	 * @generated
	 */
	EList<ResourceRequirement> getRequirements();

	/**
	 * Returns the value of the '<em><b>Cps</b></em>' container reference.
	 * It is bidirectional and its opposite is '{@link org.eclipse.viatra.examples.cps.cyberPhysicalSystem.CyberPhysicalSystem#getAppTypes <em>App Types</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * <!-- begin-model-doc -->
	 * A reference to the container instance.
	 * <!-- end-model-doc -->
	 * @return the value of the '<em>Cps</em>' container reference.
	 * @see #setCps(CyberPhysicalSystem)
	 * @see org.eclipse.viatra.examples.cps.cyberPhysicalSystem.CyberPhysicalSystemPackage#getApplicationType_Cps()
	 * @see org.eclipse.viatra.examples.cps.cyberPhysicalSystem.CyberPhysicalSystem#getAppTypes
	 * @model opposite="appTypes" required="true" transient="false"
	 * @generated
	 */
	CyberPhysicalSystem getCps();

	/**
	 * Sets the value of the '{@link org.eclipse.viatra.examples.cps.cyberPhysicalSystem.ApplicationType#getCps <em>Cps</em>}' container reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Cps</em>' container reference.
	 * @see #getCps()
	 * @generated
	 */
	void setCps(CyberPhysicalSystem value);

	/**
	 * Returns the value of the '<em><b>Instances</b></em>' containment reference list.
	 * The list contents are of type {@link org.eclipse.viatra.examples.cps.cyberPhysicalSystem.ApplicationInstance}.
	 * It is bidirectional and its opposite is '{@link org.eclipse.viatra.examples.cps.cyberPhysicalSystem.ApplicationInstance#getType <em>Type</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * <!-- begin-model-doc -->
	 * All known instances of this type.
	 * <!-- end-model-doc -->
	 * @return the value of the '<em>Instances</em>' containment reference list.
	 * @see org.eclipse.viatra.examples.cps.cyberPhysicalSystem.CyberPhysicalSystemPackage#getApplicationType_Instances()
	 * @see org.eclipse.viatra.examples.cps.cyberPhysicalSystem.ApplicationInstance#getType
	 * @model opposite="type" containment="true" resolveProxies="true"
	 * @generated
	 */
	EList<ApplicationInstance> getInstances();

	/**
	 * Returns the value of the '<em><b>Behavior</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * <!-- begin-model-doc -->
	 * An optional state machine describing the behavior of the application.
	 * <!-- end-model-doc -->
	 * @return the value of the '<em>Behavior</em>' containment reference.
	 * @see #setBehavior(StateMachine)
	 * @see org.eclipse.viatra.examples.cps.cyberPhysicalSystem.CyberPhysicalSystemPackage#getApplicationType_Behavior()
	 * @model containment="true" resolveProxies="true"
	 * @generated
	 */
	StateMachine getBehavior();

	/**
	 * Sets the value of the '{@link org.eclipse.viatra.examples.cps.cyberPhysicalSystem.ApplicationType#getBehavior <em>Behavior</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Behavior</em>' containment reference.
	 * @see #getBehavior()
	 * @generated
	 */
	void setBehavior(StateMachine value);

	/**
	 * Returns the value of the '<em><b>Exe File Size</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * <!-- begin-model-doc -->
	 * The size of the executable in bytes.
	 * <!-- end-model-doc -->
	 * @return the value of the '<em>Exe File Size</em>' attribute.
	 * @see #setExeFileSize(long)
	 * @see org.eclipse.viatra.examples.cps.cyberPhysicalSystem.CyberPhysicalSystemPackage#getApplicationType_ExeFileSize()
	 * @model
	 * @generated
	 */
	long getExeFileSize();

	/**
	 * Sets the value of the '{@link org.eclipse.viatra.examples.cps.cyberPhysicalSystem.ApplicationType#getExeFileSize <em>Exe File Size</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Exe File Size</em>' attribute.
	 * @see #getExeFileSize()
	 * @generated
	 */
	void setExeFileSize(long value);

} // ApplicationType
