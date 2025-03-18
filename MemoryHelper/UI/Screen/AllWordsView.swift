import SwiftUI

struct AllWordsView: View {
    @Bindable var viewModel: WordViewModel

    var body: some View {
        AllWordsListView(viewModel: AllWordsViewModel(wordsViewodel: viewModel))
    }
}

private struct AllWordsListView: View {
    @Bindable var viewModel: AllWordsViewModel
    @State var isEditing = false
    @FocusState private var isFocused: Bool
    @Environment(\.dismiss) var dismiss
    @State private var isShowConfirmedDialog = false
    
    var body: some View {
        GeometryReader { geometry in
            let screenWidthSize = geometry.size.width
            let rows = viewModel.arrangeWordsIntoRow(maxWidth: screenWidthSize - 5)
            ScrollView() {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(rows, id: \.self) { row in
                        HStack(spacing: 10) {
                            ForEach(row) { word in
                                WordView(viewModel: viewModel, word: word, isEdit: $isEditing, screenWidth: screenWidthSize)
                            }
                        }
                    }
                    withAnimation {
                        AddButton(viewModel: viewModel, isFocused: _isFocused, screenWidth: screenWidthSize)
                            .opacity(isEditing ? 0 : 1)
                            .disabled(isEditing)
                            .padding(.trailing, 25)
                    }
              }
                .padding(.leading, 30)
            }
            .scrollIndicators(.hidden)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 15)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                HStack(spacing: 0) {
                    Button {
                        if viewModel.selectedWords.isEmpty {
                            isEditing.toggle()
                        } else {
                            isShowConfirmedDialog = true
                        }
                    } label: {
                        Image(systemName: viewModel.selectedWords.isEmpty ? (isEditing ? "checkmark" : "pencil") : "trash")
                    }
                }
            }
            
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 0) {
                        Image(systemName: "chevron.left")
                        Text("Назад")
                            .font(.custom("Arial", size: 20))
                    }
                }

            }
        }
        .alert("Удалить выбранные слова", isPresented: $isShowConfirmedDialog, actions: {
            Button("Да", role: .destructive) {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isEditing = false
                    viewModel.deleteWord()
                }
            }
            Button("Нет", role: .cancel) {  }
        })
        .navigationBarBackButtonHidden(true)
        .onTapGesture {
            isFocused = false
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
    @Binding var isEdit: Bool
    
    let screenWidth: CGFloat
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            if isEdit {
                DeleteButton(word: word, viewModel: viewModel) 
            }
      
            Text(showTranslation ? word.translation : word.original)
                .customWordView(screenWidth: screenWidth)
                .onTapGesture {
                    withAnimation {
                        showTranslation.toggle()
                    }
                }
                .rotationEffect(.degrees(isEdit ? 3 : 0))
                .animation(
                    isEdit
                    ? .easeInOut(duration: 0.1).repeatForever()
                    : .easeInOut(duration: 0.2),
                    value: isEdit
                )
                .disabled(isEdit)
        }
    }
}

private struct DeleteButton: View {
    let word: Word
    @Bindable var viewModel: AllWordsViewModel

    @State private var isMark = false
    
    var body: some View {
        Button() {
            isMark.toggle()
            if isMark {
                viewModel.selectedWords.append(word)
            } else {
                viewModel.selectedWords.removeAll(where: { $0 == word })
            }
        } label: {
            Image(systemName: isMark ? "checkmark.circle.fill" : "circle")
                .frame(width: 20, height: 20)
                .shadow(radius: 6, x: 10, y: 10)
                .foregroundStyle(.blue)
        }
        .zIndex(1)
    }
}

private struct AddButton: View {
    @Bindable var viewModel: AllWordsViewModel
    @State var editing: Bool = false
    @FocusState var isFocused: Bool
    let screenWidth: CGFloat
    
    var body: some View {
        if viewModel.isAddingNewWord == true {
            DesignTextField(text: $viewModel.newWord, editing: $editing)
            .onSubmit {
                viewModel.addNewWord(viewModel.newWord)
            }
            .padding(.trailing, 10)
            .focused($isFocused)
        } else {
            Button(action: {
                viewModel.isAddingNewWord = true
                isFocused = true
            }) {
                Text("+ Добавить слово")
                    .customWordView(screenWidth: screenWidth)
            }
        }
        
    }
}
