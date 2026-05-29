import SwiftUI

struct SettingsView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @StateObject private var viewModel: SettingsViewModel
    
    init(managedObjectContext: NSManagedObjectContext? = nil) {
        let context = managedObjectContext ?? CoreDataManager.shared.container.viewContext
        _viewModel = StateObject(wrappedValue: SettingsViewModel(context: context))
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Constants.Colors.background.ignoresSafeArea()
                
                VStack(spacing: Constants.Dimensions.padding) {
                    Form {
                        Section(header: Text("Profile")) {
                            TextField("Name", text: $viewModel.userName)
                        }
                        
                        Section(header: Text("Daily Goal")) {
                            TextField("Calorie Goal", text: $viewModel.dailyGoalString)
                                .keyboardType(.numberPad)
                            Text("Set your daily calorie intake target")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        
                        Section {
                            Button(action: viewModel.saveChanges) {
                                if viewModel.isSaving {
                                    HStack {
                                        ProgressView()
                                            .progressViewStyle(.circular)
                                        Text("Saving...")
                                    }
                                    .frame(maxWidth: .infinity)
                                    .foregroundColor(.white)
                                } else {
                                    Text("Save Changes")
                                        .frame(maxWidth: .infinity)
                                        .foregroundColor(.white)
                                }
                            }
                            .listRowBackground(Constants.Colors.primary)
                            .disabled(viewModel.isSaving)
                        }
                        
                        Section(header: Text("About")) {
                            HStack {
                                Text("Version")
                                Spacer()
                                Text("0.1.0")
                                    .foregroundColor(.gray)
                            }
                            
                            HStack {
                                Text("App Name")
                                Spacer()
                                Text("Pungu Pal")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    
                    Spacer()
                }
            }
            .navigationTitle(Constants.Strings.settings)
            .onAppear {
                viewModel.loadUserData()
            }
        }
    }
}

#Preview {
    SettingsView()
        .environment(\.managedObjectContext, CoreDataManager.shared.container.viewContext)
}
