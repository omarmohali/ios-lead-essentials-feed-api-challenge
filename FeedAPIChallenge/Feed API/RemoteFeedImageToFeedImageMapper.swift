//
//  RemoteFeedImageToFeedImageMapper.swift
//  FeedAPIChallenge
//
//  Created by Omar Ali on 12/09/2021.
//  Copyright © 2021 Essential Developer Ltd. All rights reserved.
//

import Foundation

final class RemoteFeedImageToFeedImageMapper {
	
	private init() {}

	static func map(from remoteFeedImages: [RemoteFeedImage]) -> [FeedImage] {
		return remoteFeedImages.map {
			remoteFeedImage in
			return FeedImage(id: remoteFeedImage.id,
			                 description: remoteFeedImage.description,
			                 location: remoteFeedImage.location,
			                 url: remoteFeedImage.url)
		}
	}
}
