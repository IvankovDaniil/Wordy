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
    @State var isEditing = false
    
    var body: some View {
        GeometryReader { geometry in
            let screenWidthSize = geometry.size.width
            let rows = viewModel.arrangeWordsIntoRow(maxWidth: screenWidthSize - 5)
            ScrollView() {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(rows, id: \.self) { row in
                        HStack(spacing: 10) {
                            ForEach(row) { word in
                                WordView(viewModel: viewModel, word: word, isEdit: isEditing)
                            }
                        }
                    }
                    withAnimation {
                        AddButton(viewModel: viewModel)
                            .opacity(isEditing ? 0 : 1)
                            .disabled(isEditing)
                    }
              }
                .padding(.leading, 10)
            }
            .scrollIndicators(.hidden)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isEditing.toggle()
                } label: {
                    Image(systemName: "pencil")
                }

            }
        }
        .onLongPressGesture {
            isEditing.toggle()
        }

    }
}

private struct WordView: View {
    @Bindable var viewModel: AllWordsViewModel
    let word: Word
    @State var showTranslation = false
    
    @State private var isShowConfirmedDialog = false
    
    let isEdit: Bool
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            if isEdit {
                Button(role: .destructive) {
                    isShowConfirmedDialog = true
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .background(Circle().fill(.white))
                        .frame(width: 20, height: 20)
                        .shadow(radius: 6, x: 10, y: 10)
                }
                .zIndex(1)
                .confirmationDialog(
                    "Вы уверены, что хотите удалить \(word.original) - \(word.translation)",
                    isPresented: $isShowConfirmedDialog,
                    titleVisibility: .visible)
                {
                    Button("Да", role: .destructive) {
                        withAnimation {
                            viewModel.wordsViewodel.deleteWord(word)
                        }
                    }
                    Button("Нет", role: .cancel) {  }
                }

            }
            
            Text(showTranslation ? word.translation : word.original)
                .customWordView()
                .onTapGesture {
                    withAnimation {
                        showTranslation.toggle()
                    }
                }
                .rotationEffect(.degrees(isEdit ? 3 : 0))
                .animation(
                    isEdit
                        ? .easeInOut(duration: 0.1).repeatForever(autoreverses: true)
                        : .default,
                    value: isEdit
                )
                .disabled(isEdit)
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
