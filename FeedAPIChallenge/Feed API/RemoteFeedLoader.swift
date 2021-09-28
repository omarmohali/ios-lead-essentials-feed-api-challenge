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
			guard let self = self else { return }
			switch result {
			case let .success((data, response)):
				completion(self.map(with: data, statusCode: response.statusCode))
			case .failure:
				completion(.failure(RemoteFeedLoader.Error.connectivity))
			}
		}
	}

	private func map(with data: Data, statusCode: Int) -> FeedLoader.Result {
		let decoder = JSONDecoder()
		if let apiResponse = try? decoder.decode(RemoteFeedImages.self, from: data), statusCode == 200 {
			return .success(RemoteFeedImageToFeedImageMapper.map(from: apiResponse.items))
		} else {
			return .failure(RemoteFeedLoader.Error.invalidData)
		}
	}
}
