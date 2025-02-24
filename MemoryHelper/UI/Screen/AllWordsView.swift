import SwiftUI

struct AllWordsView: View {
    @Environment(\.modelContext) var modelContext
    @Binding var viewModel: WordViewModel
    var allWordsViewModel = AllWordsViewModel()
    @State var expandedWordId: String? = nil
    
    var body: some View {
        GeometryReader { geometry in
            let screenWidthSize = geometry.size.width
            let rows = allWordsViewModel.arrangeWordsIntoRow(viewModel.words, maxWidth: screenWidthSize - 10)
            
            VStack(alignment: .leading, spacing: 10) {
                ForEach(rows, id: \.self) { row in
                    HStack(spacing: 10) {
                        ForEach(row) { word in
                            WordView(word: word, showTranslation: expandedWordId == word.original)
                                .onTapGesture {
                                    withAnimation {
                                        expandedWordId = (expandedWordId == word.original) ? nil : word.original
                                    }
                                }
                        }
                    }
                }
            }
        }
    }
}

private struct WordView: View {
    let word: Word
    var showTranslation = false
    
    var body: some View {
        VStack(spacing: 10) {
            Text(showTranslation ? word.translation : word.original)
                .font(.custom("Arial", size: 24))
                .lineLimit(1)
                .fixedSize(horizontal: false, vertical: true)
                .padding()
                .background(Color.gray.opacity(0.2))
                .clipShape(Capsule())
                .overlay {
                    Capsule()
                        .stroke()
                }
        }
    }
}
