import SwiftUI

struct AllWordsView: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var viewModel: WordViewModel

    var body: some View {
        AllWordsListView(viewModel: AllWordsViewModel(wordsViewodel: viewModel))
    }
}

private struct AllWordsListView: View {
    @Bindable var viewModel: AllWordsViewModel
    
    var body: some View {
        GeometryReader { geometry in
            let screenWidthSize = geometry.size.width
            let rows = viewModel.arrangeWordsIntoRow(maxWidth: screenWidthSize - 5)
            ScrollView() {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(rows, id: \.self) { row in
                        HStack(spacing: 10) {
                            ForEach(row) { word in
                                WordView(word: word)
                                    .contextMenu {
                                        AllWordsContextMenuView()
                                            .overlay {
                                                Rectangle().stroke()
                                            }
                                    }
                            }
                        }
                    }
                    AddButton(viewModel: viewModel)
                }
                .padding(.leading, 10)
            }
            .scrollIndicators(.hidden)
        }

    }
}

private struct WordView: View {
    let word: Word
    @State var showTranslation = false
    
    var body: some View {
        VStack(spacing: 10) {
            Text(showTranslation ? word.translation : word.original)
                .customWordView()
                .onTapGesture {
                    withAnimation {
                        showTranslation.toggle()
                    }
                }
        }
    }
}

private struct AddButton: View {
    @Bindable var viewModel: AllWordsViewModel
    
    var body: some View {
        if viewModel.wordsViewodel.isAddingNewWord == true {
            TextField("Добавить слово", text: $viewModel.wordsViewodel.newWord)
            .onSubmit {
                
                viewModel.wordsViewodel.addNewWord(viewModel.wordsViewodel.newWord)
            }
            .customWordView()
            .padding(.trailing, 10)
        } else {
            Button(action: {
                viewModel.wordsViewodel.isAddingNewWord = true
            }) {
                Text("+ Добавить слово")
                    .customWordView()
            }
        }
        
    }
}

private struct AllWordsContextMenuView: View {
    
    
    var body: some View {
        VStack(spacing: 0) {
            Button {
                //
            } label: {
                Text("Редактировать")
                Image(systemName: "pencil")
            }
            
            Button(role: .destructive) {
                //
            } label: {
                Text("Удалить")
                Image(systemName: "trash.fill")
            }
        }
    }
}
