import SwiftUI
import TipKit

struct AllWordsView: View {
    @Bindable var viewModel: WordViewModel
    @AppStorage("selectedLanguage") private var selectedLanguageRow: String = Language.english.rawValue
    var selectedLanguage: Language {
        get { Language(rawValue: selectedLanguageRow) ?? .english }
        set { selectedLanguageRow = newValue.rawValue }
    }
    
    var body: some View {
        AllWordsListView(viewModel:
                            AllWordsViewModel(wordsViewodel: viewModel, selectedLanguage: selectedLanguage))
    }
}

private struct AllWordsListView: View {
    @Bindable var viewModel: AllWordsViewModel
    @State var isEditing = false
    @FocusState private var isFocused: Bool
    @Environment(\.dismiss) var dismiss
    @State private var isShowConfirmedDialog = false
    @State private var isSheetOpen = false
    
    @State private var showErrorMessage = false
    @State private var errorMessage: String? = nil
    
    let addNewWordTip = AddNewWordTip()
    let deleteWordsTip = DeleteWordsTip()
    
    @AppStorage("selectedLanguage") private var selectedLanguageRow: String = Language.english.rawValue
    var selectedLanguage: Language {
        get { Language(rawValue: selectedLanguageRow) ?? .english }
        set { selectedLanguageRow = newValue.rawValue }
    }
    
    var body: some View {
        GeometryReader { geometry in
            let screenWidthSize = geometry.size.width
            let rows = viewModel.arrangeWordsIntoRow(maxWidth: screenWidthSize - 15)
            WordsGridView(rows: rows,
                          screenWidthSize: screenWidthSize,
                          isEditing: $isEditing,
                          viewModel: viewModel)
        }
        .overlay(alignment: .top) {
            if showErrorMessage, let errorMessage = errorMessage {
                ToastView(message: errorMessage)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .displayError)) { notification in
            if let error = notification.userInfo?["error"] as? String {
                Task { @MainActor in
                    errorMessage = error
                    showErrorMessage = true
                    try? await Task.sleep(nanoseconds: 3_000_000_000)
                    showErrorMessage = false
                    errorMessage = nil
                }
            }
        }
        
        .sheet(isPresented: $isSheetOpen, content: {
            AddNewWordView(viewModel: viewModel)
                .presentationDetents([.height(300)])
        })
        .frame(maxWidth: .infinity)
        .toolbar {
            toolbarContent()
        }
        .alert("Удалить выбранные слова", isPresented: $isShowConfirmedDialog, actions: {
            Button("Да", role: .destructive) {
                withAnimation(.easeInOut(duration: 0.2)) {
                    Haptic.notify(.success)
                    isEditing = false
                    viewModel.deleteWord()
                }
            }
            Button("Нет", role: .cancel) {
                Haptic.notify(.warning)
            }
        })
        .navigationBarBackButtonHidden(true)
        .onTapGesture {
            isFocused = false
        }
        .onLongPressGesture {
            isEditing.toggle()
            Haptic.notify(.success)
        }
        
    }
    
    private func toolbarContent() -> some ToolbarContent {
        Group {
            ToolbarItem(placement: .topBarTrailing) {
                HStack() {
                    Image(selectedLanguage.flag)
                        .resizable()
                        .frame(width: 30, height: 30)
                        .clipShape(Circle())
                    
                    Button {
                        if viewModel.selectedWords.isEmpty {
                            isEditing.toggle()
                            Haptic.notify(.success)
                        } else {
                            isShowConfirmedDialog = true
                            Haptic.notify(.success)
                        }
                    } label: {
                        Image(systemName: viewModel.selectedWords.isEmpty ? (isEditing ? "checkmark" : "pencil") : "trash")
                            .foregroundStyle(.mainViolet)
                    }
                    .popoverTip(deleteWordsTip)
                    .tipImageStyle(.mainViolet)
                }
                
            }
            
            ToolbarItem(placement: .principal) {
                Image(.eyes)
                    .resizable()
                    .frame(width: 100, height: 100)
            }
            
            ToolbarItem(placement: .topBarLeading) {
                if viewModel.words.count < 50 {
                    Button {
                        Haptic.notify(.success)
                        isSheetOpen = true
                    } label: {
                        Image(systemName: "plus.square")
                            .foregroundStyle(.mainViolet)
                    }
                    .popoverTip(addNewWordTip)
                    .tipImageStyle(.mainGreen)
                    .opacity(isEditing ? 0 : 1)
                    .disabled(isEditing)
                }
            }
        }
    }
}

private struct WordsGridView: View {
    let rows: [[Word]]
    let screenWidthSize: CGFloat
    @Binding var isEditing: Bool
    @Bindable var viewModel: AllWordsViewModel
    
    var body: some View {
        ScrollView() {
            ZStack(alignment: .topLeading) {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(rows, id: \.self) { row in
                        HStack(spacing: 10) {
                            ForEach(row) { word in
                                WordView(viewModel: viewModel, word: word, isEdit: $isEditing, screenWidth: screenWidthSize)
                            }
                        }
                    }
                }
                .padding(.leading, 30)
                .padding(.trailing, 16)
                
                if viewModel.words.isEmpty {
                    Image(.arrow)
                        .resizable()
                        .frame(width: 120, height: 100)
                        .padding(.leading)
                        .offset(y: -80)
                }
            }
            
        }
        .scrollIndicators(.hidden)
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
                        Haptic.notify(.success)
                    }
                }
                .rotationEffect(.degrees(isEdit ? 2 : 0))
                .scaleEffect(isEdit ? 1.02 : 1.0)
                .animation(
                    isEdit
                    ? .spring(duration: 0.1).repeatForever()
                    : .spring(duration: 0.2),
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


private struct AddNewWordView: View {
    
    @Environment(\.dismiss) var dismiss
    @Bindable var viewModel: AllWordsViewModel
    @State private var isEditing = false
    @FocusState var isFocused: Bool
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                DesignTextField(text: $viewModel.newWord, editing: $isEditing)
                    .focused($isFocused)
                
                Button {
                    if viewModel.newWord != "" {
                        viewModel.addNewWord(viewModel.newWord)
                        dismiss()
                        Haptic.notify(.success)
                    } else {
                        Haptic.notify(.warning)
                    }
                } label: {
                    Text("ДОБАВИТЬ")
                        .wordTextModifier(color: .mainViolet)
                }
                .padding(.top, 10)
                
            }
            .onTapGesture {
                isFocused = false
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        Haptic.notify(.success)
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(.mainViolet)
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        if viewModel.newWord != "" {
                            Haptic.notify(.success)
                            viewModel.addNewWord(viewModel.newWord)
                            dismiss()
                        } else {
                            Haptic.notify(.warning)
                        }
                    } label: {
                        Image(systemName: "plus")
                            .foregroundStyle(.mainViolet)
                    }
                    
                }
            }
        }
    }
}


private struct ToastView: View {
    let message: String
    
    var body: some View {
        Text(message)
            .font(.custom("Arial Black", size: 16))
            .foregroundStyle(.white)
            .padding()
            .background(Color.red.opacity(0.8))
            .clipShape(.rect(cornerRadius: 12))
            .shadow(radius: 5)
            .transition(.move(edge: .bottom).combined(with: .opacity))
    }
}
