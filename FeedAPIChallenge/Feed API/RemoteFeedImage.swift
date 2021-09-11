//
//  RemoteFeedImage.swift
//  FeedAPIChallenge
//
//  Created by Omar Ali on 12/09/2021.
//  Copyright © 2021 Essential Developer Ltd. All rights reserved.
//

import Foundation

struct RemoteFeedImages: Decodable {
	let items: [RemoteFeedImage]
}

struct RemoteFeedImage: Decodable {
	let id: UUID
	let description: String?
	let location: String?
	let url: URL

	enum CodingKeys: String, CodingKey {
		case id = "image_id"
		case description = "image_desc"
		case location = "image_loc"
		case url = "image_url"
	}
}
