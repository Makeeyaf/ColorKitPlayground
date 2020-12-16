//
//  ViewController.swift
//  ColorKitPlayground
//
//  Created by Makeeyaf on 2020/12/16.
//

import UIKit
import Combine

import ColorKit
import SnapKit

class ViewController: UIViewController {
    struct UnsplashImage {
        let name: String
        let credit: String
    }

    let imageData = [
        UnsplashImage(name: "yellow", credit: "Photo by Lucas George Wendt on Unsplash"),
        UnsplashImage(name: "skyblue", credit: "Photo by kriti tara on Unsplash"),
        UnsplashImage(name: "black", credit: "Photo by rishi on Unsplash"),
        UnsplashImage(name: "green", credit: "Photo by Markus Spiske on Unsplash"),
    ]

    @Published var imageIndex: Int = 0
    var bag: Set<AnyCancellable> = []

    // MARK: Views

    lazy var imageContainer: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 6
        return view
    }()

    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        view.contentMode = .scaleAspectFit
        return view
    }()

    lazy var creditLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 16, weight: .semibold)
        view.textAlignment = .center
        return view
    }()

    lazy var changeButton: UIButton = {
        let view = UIButton(type: .system)
        view.setTitle("Change", for: .normal)
        view.addTarget(self, action: #selector(test), for: .touchUpInside)
        return view
    }()

    @objc func test() {
        imageIndex = (imageIndex + 1 < imageData.count) ? imageIndex + 1 : 0
    }

    // MARK: Lifecycles

    override func viewDidLoad() {
        super.viewDidLoad()
        setBindings()
        addViews()
        setConstraints()
    }

    func setBindings() {
        $imageIndex.receive(on: DispatchQueue.main)
            .sink { [unowned self] index in
                imageView.image = UIImage(named: imageData[imageIndex].name)
                creditLabel.text = imageData[imageIndex].credit

                let colors: [UIColor] = (try? imageView.image?.dominantColors()) ?? []
                let palette = ColorPalette(colors: colors, ignoreContrastRatio: true)
                imageContainer.backgroundColor = palette?.background
                creditLabel.textColor = palette?.primary
            }
            .store(in: &bag)
    }

    func addViews() {
        [imageContainer, changeButton].forEach {
            view.addSubview($0)
        }

        [imageView, creditLabel].forEach {
            imageContainer.addSubview($0)
        }
    }

    func setConstraints() {
        imageContainer.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.width.equalTo(imageContainer.snp.height)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(18)
        }

        imageView.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview().inset(8)
            $0.bottom.equalToSuperview().inset(40)
        }

        creditLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(8)
        }

        changeButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
