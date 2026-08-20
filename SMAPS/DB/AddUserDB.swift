//
//  AddUser.swift
//  SMAPS
//
//  Created by Danxd on 6/15/26.
//

import Foundation
import SwiftData


@Model
final class AddUserData: Identifiable {
    var userid: String
    var firstName: String
    var middleName: String?
    var lastName: String
    var email: String
    var contactNumber: String
    var sitio: String
    var barangay: String
    var city: String
    var province: String
    var postalCode: String
    var status: String?
    
    init(userid: String, firstName: String, middleName: String? = nil, lastName: String, email: String, contactNumber: String, sitio: String, barangay: String, city: String, province: String, postalCode: String, status: String? = nil) {
        self.userid = userid
        self.firstName = firstName
        self.middleName = middleName
        self.lastName = lastName
        self.email = email
        self.contactNumber = contactNumber
        self.sitio = sitio
        self.barangay = barangay
        self.city = city
        self.province = province
        self.postalCode = postalCode
        self.status = status
    }
}

@Model
final class AddDocs: Identifiable {
    var imageid: String
    var userid: String
    var path: String
    
    init(imageid: String, userid: String, path: String) {
        self.imageid = imageid
        self.userid = userid
        self.path = path
    }
}

@Model
final class AddTrees: Identifiable {
    var treeid: String
    var userid: String
    var treetype: String
    var numberofTrees: String
    var estkg: String
    
    init(treeid: String, userid: String, treetype: String, numberofTrees: String, estkg: String) {
        self.treeid = treeid
        self.userid = userid
        self.treetype = treetype
        self.numberofTrees = numberofTrees
        self.estkg = estkg
    }
}
