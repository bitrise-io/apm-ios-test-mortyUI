//
//  CharacterDetailView.swift
//  MortyUI
//
//  Created by Thomas Ricouard on 19/12/2020.
//

import SwiftUI
import Apollo
import KingfisherSwiftUI

struct CharacterDetailView: View {
    @StateObject private var query: SingleQuery<GetCharacterQuery>
    
    init(id: GraphQLID) {
        _query = StateObject(wrappedValue: SingleQuery(query: GetCharacterQuery(id: id)))
    }
    
    var body: some View {
        List {
            Section(header: Text("Mugshot")) {
                HStack {
                    Spacer()
                    if let image = query.data?.character?.image,
                       let url = URL(string: image) {
                        KFImage(url)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 150, height: 150)
                            .cornerRadius(25)
                    } else {
                        RoundedRectangle(cornerRadius: 25)
                            .frame(width: 150, height: 150)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                }
            }
            
            infoSection

            if let episodes = query.data?.character?.episode?.compactMap{ $0 } {
                Section(header: Text("Episodes")) {
                    ForEach(episodes, id: \.id) { episode in
                        NavigationLink(
                            destination: EpisodeDetailView(id: episode.id!),
                            label: {
                                HStack {
                                    Text(episode.name!)
                                    Spacer()
                                    Text(episode.airDate!)
                                        .foregroundColor(.gray)
                                        .font(.footnote)
                                }
                            })
                    }
                }
            }
            
        }
        .listStyle(GroupedListStyle())
        .navigationTitle(query.data?.character?.name ?? "Loading...")
    }
    
    private var infoSection: some View {
        Section(header: Text("Info"),
                content: {
                    InfoRowView(label: "Species",
                                icon: "hare",
                                value: query.data?.character?.species ?? "loading...")
                    InfoRowView(label: "Gender",
                                icon: "eyes",
                                value: query.data?.character?.gender ?? "loading...")
                    InfoRowView(label: "Status",
                                icon: "waveform.path.ecg.rectangle",
                                value: query.data?.character?.status ?? "loading...")
                    InfoRowView(label: "Location",
                                icon: "map",
                                value: query.data?.character?.location?.name ?? "loading...")
                    InfoRowView(label: "Origin",
                                icon: "paperplane",
                                value: query.data?.character?.origin?.name ?? "loading...")
                })
            .redacted(reason: query.data?.character == nil ? .placeholder : [])
    }
}

struct CharacterDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CharacterDetailView(id: GraphQLID(1))
        }
    }
}
