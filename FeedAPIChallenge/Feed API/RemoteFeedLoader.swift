//
//  Copyright © 2018 Essential Developer. All rights reserved.
//

import Foundation

struct RemoteAPIResponse: Decodable {
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

class RemoteFeedImageToFeedImageMapper {
	static func getFeedImages(from remoteFeedImages: [RemoteFeedImage]) -> [FeedImage] {
		return remoteFeedImages.map {
			remoteFeedImage in
			return FeedImage(id: remoteFeedImage.id,
			                 description: remoteFeedImage.description,
			                 location: remoteFeedImage.location,
			                 url: remoteFeedImage.url)
		}
	}
}

public final class RemoteFeedLoader: FeedLoader {
	private let url: URL
	private let client: HTTPClient

	public enum Error: Swift.Error {
		case connectivity
		case invalidData
	}

	public init(url: URL, client: HTTPClient) {
		self.url = url
		self.client = client
	}

	public func load(completion: @escaping (FeedLoader.Result) -> Void) {
		client.get(from: url) {
			result in
			switch result {
			case let .success((data, response)):
				if response.statusCode == 200 {
					let decoder = JSONDecoder()
					if let apiResponse = try? decoder.decode(RemoteAPIResponse.self, from: data) {
						completion(.success(RemoteFeedImageToFeedImageMapper.getFeedImages(from: apiResponse.items)))
					} else {
						completion(.failure(RemoteFeedLoader.Error.invalidData))
					}
				} else {
					completion(.failure(RemoteFeedLoader.Error.invalidData))
				}
			case .failure:
				completion(.failure(RemoteFeedLoader.Error.connectivity))
			}
		}
	}
}
