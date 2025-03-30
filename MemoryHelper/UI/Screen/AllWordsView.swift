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
                    if viewModel.words.count < 50 {
                        withAnimation {
                            AddButton(viewModel: viewModel, isFocused: _isFocused, screenWidth: screenWidthSize)
                                .opacity(isEditing ? 0 : 1)
                                .disabled(isEditing)
                                .padding(.trailing, 25)
                        }
                    }
              }
                .padding(.top, 15)
                .padding(.leading, 30)
                .padding(.trailing, 16)
            }
            .scrollIndicators(.hidden)
        }
        .frame(maxWidth: .infinity)
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
                            .foregroundStyle(.mainGreen)
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
                    .foregroundStyle(.mainGreen)
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
    @State var isMark: Bool = false
    
    let screenWidth: CGFloat
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            if isEdit {
                DeleteButton(word: word, viewModel: viewModel, isMark: $isMark)
            }
      
            Text(showTranslation ? word.translation : word.original)
                .customWordView(screenWidth: screenWidth, color: .mainGreen)
                .onTapGesture {
                    withAnimation {
                        showTranslation.toggle()
                    }
                }
                .rotationEffect(.degrees(isEdit ? 2 : 0))
                .scaleEffect(isEdit ? 1.02 : 1.0)
                .animation(
                    isEdit
                    ? .easeInOut(duration: 0.1).repeatForever()
                    : .easeInOut(duration: 0.2),
                    value: isEdit
                )
                .disabled(isEdit)
        }
        .onTapGesture {
            isMark.toggle()
            if isMark {
                if !viewModel.selectedWords.contains(word) {
                    viewModel.selectedWords.append(word)
                }
            } else {
                viewModel.selectedWords.removeAll(where: { $0 == word })
            }
        }
    }
}

private struct DeleteButton: View {
    let word: Word
    @Bindable var viewModel: AllWordsViewModel

    @Binding var isMark: Bool
    
    var body: some View {
        Image(systemName: isMark ? "checkmark.circle.fill" : "circle")
            .frame(width: 20, height: 20)
            .shadow(radius: 6, x: 10, y: 10)
            .foregroundStyle(.mainViolet)
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
            HStack(alignment: .top) {
                DesignTextField(text: $viewModel.newWord, editing: $editing)
                    .onSubmit {
                        viewModel.addNewWord(viewModel.newWord)
                    }
                    .padding(.trailing, 10)
                    .focused($isFocused)
                Button {
                    viewModel.addNewWord(viewModel.newWord)
                    isFocused = false
                } label: {
                    Image(systemName: "checkmark")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
                .padding(.top, 10)
                .foregroundStyle(.mainViolet)
            }
        } else {
            Button(action: {
                viewModel.isAddingNewWord = true
                isFocused = true
            }) {
                Text("+ Добавить слово")
                    .foregroundStyle(.white)
                    .customWordView(screenWidth: screenWidth, color: .mainViolet)
            }
        }
        
    }
}
