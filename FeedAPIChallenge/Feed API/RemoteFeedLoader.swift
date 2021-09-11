//
//  Copyright © 2018 Essential Developer. All rights reserved.
//

import Foundation

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
			[weak self] result in
			switch result {
			case let .success((data, response)):
				if response.statusCode == 200 {
					self?.handleLoadFeedSuccess(with: data, completion: completion)
				} else {
					completion(.failure(RemoteFeedLoader.Error.invalidData))
				}
			case .failure:
				completion(.failure(RemoteFeedLoader.Error.connectivity))
			}
		}
	}

	private func handleLoadFeedSuccess(with data: Data, completion: @escaping (FeedLoader.Result) -> Void) {
		let decoder = JSONDecoder()
		if let apiResponse = try? decoder.decode(RemoteFeedImages.self, from: data) {
			completion(.success(RemoteFeedImageToFeedImageMapper.getFeedImages(from: apiResponse.items)))
		} else {
			completion(.failure(RemoteFeedLoader.Error.invalidData))
		}
	}
}
