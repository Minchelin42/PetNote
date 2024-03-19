//
//  PlaceModel.swift
//  PetDiary
//
//  Created by 민지은 on 2024/03/16.
//

import Foundation

struct Place: Decodable {
    let response: Response
}

struct Response: Decodable {
    let header: Header
    let body: Body
}

struct Body: Decodable {
    let items: Items
    let numOfRows, pageNo, totalCount: String
}


struct Items: Decodable {
    let item: [AnimalPlace]
}

struct AnimalPlace: Decodable {
    let title: String
    let category1: String
    let category2: String
    let description: String
    let address: String
    let coordinates: String
}

struct Header: Decodable {
    let resultCode, resultMsg: String
}
