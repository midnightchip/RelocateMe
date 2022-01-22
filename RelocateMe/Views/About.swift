//
//  About.swift
//  RelocateMe
//
//  Created by MidnightChips on 1/20/22.
//

import SwiftUI

struct About: View {
    @EnvironmentObject var envModel: EnviromentModel
    @State var openLicense: Bool = false
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Link(destination: URL(string: "https://twitter.com/midnightchip")!, label: {
                        UserInfo(title: "MidnightChips", subTitle: "Developer", imageUrl: "https://github.com/midnightchip.png")
                    })

                    Link(destination: URL(string: "https://github.com/udevsharold/locsim")!, label: {
                        UserInfo(title: "udevs", subTitle: "locsim Developer", imageUrl: "https://github.com/udevsharold.png")
                    })

                    NavigationLink(destination: LicenseView(), isActive: $openLicense) {
                        LargeButton(title: "View Software License", backgroundColor: .accentColor, foregroundColor: .white, action: {
                            openLicense = true
                        })
                    }

                    if !envModel.isValid {
                        if let error = envModel.error {
                            Text("Error: \(error.localizedDescription)")
                                .font(.title2.bold())
                                .foregroundColor(.red)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                        
                        LargeButton(title: "Buy RelocateMe", backgroundColor: .green, foregroundColor: .white, action: {
                            if let url = URL(string: "https://chariz.com/get/relocate-me") {
                                UIApplication.shared.open(url)
                            }
                        })
                        
                        LargeButton(title: "Check License", backgroundColor: .blue, foregroundColor: .white, action: {
                            Validate().verify { res, err in
                                DispatchQueue.main.async {
                                    envModel.isValid = res
                                    envModel.error = err
                                }
                            }
                        })
                    }

                    LargeButton(title: "View Source", backgroundColor: .accentColor, foregroundColor: .white, action: {
                        if let url = URL(string: "https://github.com/midnightchip/RelocateMe") {
                            UIApplication.shared.open(url)
                        }
                    })

                    LargeButton(title: "Clear Cache", backgroundColor: .accentColor, foregroundColor: .white, action: {
                        cleanup()
                    })
                    Spacer()
                }.navigationTitle("About")
                    .navigationBarItems(trailing:
                        Button(action: {
                            envModel.selectedSheet = nil
                        }) {
                            Text("Close")
                        }
                    )
            }
        }
    }
}

struct UserInfo: View {
    @ObservedObject var imageLoader: ImageLoader
    @State var image = UIImage(systemName: "person") ?? UIImage()
    var title: String
    var subTitle: String
    init(title: String, subTitle: String, imageUrl: String) {
        imageLoader = ImageLoader(urlString: imageUrl)
        self.title = title
        self.subTitle = subTitle
    }

    var body: some View {
        HStack {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                .onReceive(imageLoader.didChange) { data in
                    self.image = UIImage(data: data) ?? UIImage(systemName: "person") ?? UIImage()
                }
            Spacer()
            VStack(alignment: .leading) {
                Text(title)
                    .font(.title2)
                Text(subTitle)
                    .font(.subheadline)
                    .opacity(0.5)
            }
            Spacer()
            Spacer()
            Spacer()
            Image(systemName: "chevron.right")
                .opacity(0.5)
                .font(.body.bold())
        }.padding()
    }
}

struct About_Previews: PreviewProvider {
    static var previews: some View {
        About()
    }
}
