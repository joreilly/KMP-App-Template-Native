import Foundation
import SwiftUI
import Shared

struct DetailView: View {
    let viewModel = DetailViewModel(
        museumRepository: KoinDependencies().museumRepository
    )
    
    let objectId: Int32
    
    @State
    var object: MuseumObject? = nil
    
    var body: some View {
        VStack {
            if let obj = object {
                ObjectDetails(obj: obj)
            }
        }.task {
            for await obj in viewModel.getObject(objectId: objectId) {
                object = obj!
            }
        }
    }
}

struct ObjectDetails: View {
    var obj: MuseumObject
    
    var body: some View {
        ScrollView {
            
            VStack {
                AsyncImage(url: URL(string: obj.primaryImageSmall)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .clipped()
                    default:
                        EmptyView()
                    }
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(obj.title)
                        .font(.title)
                    Text(obj.artistDisplayName)
                        .font(.headline)
                    Text(obj.objectDate)
                        .font(.subheadline)
                        .italic()
                    
                    Spacer().frame(height: 4)
                    
                    LabeledInfo(label: "Dimensions", data: obj.dimensions)
                    LabeledInfo(label: "Medium", data: obj.medium)
                    LabeledInfo(label: "Department", data: obj.department)
                    LabeledInfo(label: "Repository", data: obj.repository)
                    LabeledInfo(label: "Credits", data: obj.creditLine)
                }
                .padding(16)
            }
        }
    }
}

struct LabeledInfo: View {
    var label: String
    var data: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label).font(.subheadline)
            Text(data).font(.body)
        }.padding(.vertical, 4)
    }
}
