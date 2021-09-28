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

	private static let OK_200 = 200

	static func mapResponse(data: Data, statusCode: Int) -> FeedLoader.Result {
		let decoder = JSONDecoder()
		if let apiResponse = try? decoder.decode(RemoteFeedImages.self, from: data), statusCode == OK_200 {
			return .success(RemoteFeedImageToFeedImageMapper.map(from: apiResponse.items))
		} else {
			return .failure(RemoteFeedLoader.Error.invalidData)
		}
	}

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
