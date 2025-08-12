import SwiftUI
@available(iOS 15.0,*)
struct IronhollowFrostshriekView: View {
    // MARK: - Enums
    enum CryoProtocol: String, CaseIterable, Identifiable {
        case glacial = "Glacial Protocol"
        case arctic = "Arctic Protocol"
        case polar = "Polar Protocol"
        case absoluteZero = "Absolute Zero Protocol"
        var id: String { self.rawValue }
    }
    
    enum FrostMatrix: String, CaseIterable, Identifiable {
        case ice = "Ice Matrix"
        case snow = "Snow Composite"
        case hail = "Hail Alloy"
        var id: String { self.rawValue }
    }
    
    enum IntensityLevel: String, CaseIterable, Identifiable {
        case mild = "Mild"
        case moderate = "Moderate"
        case extreme = "Extreme"
        var id: String { self.rawValue }
    }
    
    // MARK: - State Variables
    @State private var coreTemperature: Double = -50
    @State private var cryoRate: Double = 2.5
    @State private var frostbiteFactor: String = ""
    @State private var stabilizerConstant: String = ""
    @State private var iterations: Int = 1
    @State private var cryoProtocol: CryoProtocol = .glacial
    @State private var frostMatrix: FrostMatrix = .ice
    @State private var intensityLevel: IntensityLevel = .moderate
    @State private var showSuccess = false
    @State private var showResults = false
    @State private var infusionResult: CryoResult?
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var alertType: AlertType = .info
    @State private var capturedImage: UIImage?
    @State private var showShareSheet = false
    @State private var resonanceFrequency: Double = 3.0
    @State private var isProcessing = false
    
    // MARK: - Constants
    private let maxCoreTemperature: Double = 0
    private let minCoreTemperature: Double = -273
    private let maxCryoRate: Double = 10.0
    
    // MARK: - Main View
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 20) {
                    headerView
                    parametersSection
                    configurationSection
                    actionButtons
                    
                    if showSuccess {
                        successView
                    }
                    
                    if showResults, let result = infusionResult {
                        resultsSection(result: result)
                    }
                }
                .padding()
            }
            .background(backgroundGradient)
            .sheet(isPresented: $showShareSheet) {
                ShareSheet(activityItems: [resultShareText, capturedImage].compactMap { $0 })
            }
            
            if showAlert {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture { dismissAlert() }
                
                FrostAlertView(
                    isPresented: $showAlert,
                    title: alertType.title,
                    message: alertMessage,
                    type: alertType
                )
                .transition(.scale.combined(with: .opacity))
                .zIndex(1)
            }
            
            if isProcessing {
                ProcessingOverlay()
            }
        }
    }
    
    // MARK: - Subviews
    private var backgroundGradient: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color.blue.opacity(0.2),
                Color.teal.opacity(0.1),
                Color.purple.opacity(0.1)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("IRONHOLLOW FROSTSHRIEK")
                    .font(.system(.largeTitle, design: .rounded))
                    .fontWeight(.black)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.blue, .teal],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                
                Text("Cryogenic Quantum Infusion Nexus")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Menu {
                Button(action: captureScreenshot) {
                    Label("Capture Frostprint", systemImage: "camera.fill")
                }
                
                if infusionResult != nil {
                    Button(action: copyResultsToClipboard) {
                        Label("Copy Cryo Data", systemImage: "doc.on.doc.fill")
                    }
                    
                    Button(action: prepareShare) {
                        Label("Share Results", systemImage: "square.and.arrow.up")
                    }
                }
                
                Button(action: showHelp) {
                    Label("Cryo Manual", systemImage: "questionmark.circle")
                }
                
                Button(action: resetForm) {
                    Label("Reset Chamber", systemImage: "arrow.clockwise")
                }
            } label: {
                Image(systemName: "ellipsis.circle.fill")
                    .font(.title2)
                    .foregroundColor(.teal)
                    .contentShape(Rectangle())
            }
        }
        .padding(.bottom, 20)
    }
    
    private var parametersSection: some View {
        FrostCardView(title: "CRYO PARAMETERS", systemImage: "thermometer.snowflake") {
            // Core Temperature Control
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "thermometer")
                        .foregroundColor(.blue)
                    
                    Text("Core Temperature")
                        .font(.headline)
                    
                    Spacer()
                    
                    Text("\(Int(coreTemperature))°K")
                        .font(.headline.monospacedDigit())
                        .foregroundColor(temperatureColor)
                }
                
                if #available(iOS 16.0, *) {
                    Slider(value: $coreTemperature, in: minCoreTemperature...maxCoreTemperature, step: 1)
                        .tint(temperatureGradient)
                } else {
                    // Fallback on earlier versions
                }
            }
            .padding(.vertical, 8)
            
            // Cryo Rate Control
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "speedometer")
                        .foregroundColor(.teal)
                    
                    Text("Cryo Injection Rate")
                        .font(.headline)
                    
                    Spacer()
                    
                    Text("\(cryoRate, specifier: "%.1f") mL/s")
                        .font(.headline.monospacedDigit())
                        .foregroundColor(.teal)
                }
                
                Slider(value: $cryoRate, in: 0.1...maxCryoRate, step: 0.1)
                    .tint(.teal)
            }
            .padding(.vertical, 8)
            
            // Text Input Fields
            FrostTextField(value: $frostbiteFactor, label: "Frostbite Factor", symbol: "function", keyboardType: .decimalPad)
            FrostTextField(value: $stabilizerConstant, label: "Stabilizer Constant", symbol: "ruler", keyboardType: .decimalPad)
            
            // Iterations Control
            HStack {
                Text("Iterations: \(iterations)")
                    .font(.headline)
                
                Spacer()
                
                Stepper(value: $iterations, in: 1...10, step: 1) {
                    EmptyView()
                }
                .labelsHidden()
            }
            .padding(.vertical, 8)
        }
    }
    
    private var configurationSection: some View {
        FrostCardView(title: "CRYO CONFIGURATION", systemImage: "gearshape.fill") {
            // Protocol Selection
            FrostMenuPicker(selection: $cryoProtocol, title: "Cryo Protocol", options: CryoProtocol.allCases)
            
            // Matrix Selection
            FrostMenuPicker(selection: $frostMatrix, title: "Frost Matrix", options: FrostMatrix.allCases)
            
            // Resonance Frequency Control
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "waveform.path.ecg")
                        .foregroundColor(.purple)
                    
                    Text("Resonance Frequency")
                        .font(.headline)
                    
                    Spacer()
                    
                    Text("\(resonanceFrequency, specifier: "%.1f") kHz")
                        .font(.headline.monospacedDigit())
                        .foregroundColor(.purple)
                }
                
                Slider(value: $resonanceFrequency, in: 1...5, step: 0.1)
                    .tint(.purple)
            }
            .padding(.vertical, 8)
            
            // Intensity Level
            VStack(alignment: .leading) {
                Text("Cryo Intensity")
                    .font(.headline)
                
                Picker("Intensity", selection: $intensityLevel) {
                    ForEach(IntensityLevel.allCases) { level in
                        Text(level.rawValue).tag(level)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.top, 8)
            }
        }
    }
    
    private var actionButtons: some View {
        HStack(spacing: 16) {
            FrostButton(
                action: validateAndStartInfusion,
                label: "Initiate Cryo Infusion",
                icon: "snowflake",
                color: .blue,
                isLoading: isProcessing
            )
            
            FrostButton(
                action: resetForm,
                label: "Reset Chamber",
                icon: "arrow.clockwise",
                color: .gray
            )
        }
    }
    

    private var successView: some View {
        FrostCardView {
            VStack(spacing: 16) {
                if #available(iOS 17.0, *) {
                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.teal)
                        .symbolEffect(.bounce, value: showSuccess)
                } else {
                    // Fallback on earlier versions
                }
                
                Text("CRYO INFUSION COMPLETE")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.teal)
                
                Text("Frost matrix stabilized at \(Int(coreTemperature))°K")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 24)
        }
    }
    
    private func resultsSection(result: CryoResult) -> some View {
        FrostCardView(title: "CRYO RESULTS", systemImage: "chart.bar.fill") {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("Results Analysis")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Button(action: { withAnimation { showResults = false } }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                }
                
                Divider()
                
                // Key Metrics
                VStack(spacing: 12) {
                    FrostMetricView(
                        icon: "bolt.fill",
                        label: "Energy Absorption",
                        value: "\(String(format: "%.2f", result.energyAbsorption)) MW",
                        color: .yellow
                    )
                    
                    FrostMetricView(
                        icon: "waveform.path.ecg",
                        label: "Stability Index",
                        value: "\(String(format: "%.1f", result.stabilityIndex))/10",
                        color: result.stabilityIndex > 7 ? .green : result.stabilityIndex > 4 ? .orange : .red
                    )
                    
                    FrostMetricView(
                        icon: "clock.fill",
                        label: "Duration",
                        value: "\(String(format: "%.1f", result.duration)) sec",
                        color: .blue
                    )
                    
                    FrostMetricView(
                        icon: "calendar",
                        label: "Timestamp",
                        value: result.timestamp.formatted(),
                        color: .secondary
                    )
                }
                
                Divider()
                
                // Recommendations
                VStack(alignment: .leading, spacing: 8) {
                    Text("Cryo Recommendations")
                        .font(.headline)
                        .padding(.bottom, 4)
                    
                    if result.stabilityIndex < 5 {
                        Text("• Increase stabilizer constant by 15-20%")
                        Text("• Reduce cryo rate by 10-15%")
                        Text("• Consider using Snow Composite matrix")
                    } else if result.energyAbsorption < 50 {
                        Text("• Increase core temperature gradient")
                        Text("• Try Arctic or Polar protocols")
                        Text("• Consider Extreme intensity setting")
                    } else {
                        Text("• Parameters are within optimal range")
                        Text("• Consider increasing iterations for deeper infusion")
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray6)))
            }
        }
    }
    
    // MARK: - Computed Properties
    private var temperatureColor: Color {
        let normalized = (coreTemperature - minCoreTemperature) / (maxCoreTemperature - minCoreTemperature)
        return Color(
            hue: 0.6 - (normalized * 0.4),
            saturation: 0.8,
            brightness: 0.9
        )
    }
    
    private var temperatureGradient: LinearGradient {
        LinearGradient(
            colors: [.blue, .teal, .purple],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
    
    private var intensityMultiplier: Double {
        switch intensityLevel {
        case .mild: return 0.7
        case .moderate: return 1.0
        case .extreme: return 1.5
        }
    }
    
    private var resultShareText: String {
        guard let result = infusionResult else { return "" }
        return result.shareableText
    }
    
    // MARK: - Actions
    private func validateAndStartInfusion() {
        guard !frostbiteFactor.isEmpty else {
            showAlert(message: "Frostbite Factor required", type: .warning)
            return
        }
        
        guard !stabilizerConstant.isEmpty else {
            showAlert(message: "Stabilizer Constant required", type: .warning)
            return
        }
        
        guard let frostValue = Double(frostbiteFactor), (1...100).contains(frostValue) else {
            showAlert(message: "Frostbite Factor must be 1-100", type: .warning)
            return
        }
        
        guard let stabilizerValue = Double(stabilizerConstant), (0.1...10).contains(stabilizerValue) else {
            showAlert(message: "Stabilizer must be 0.1-10", type: .warning)
            return
        }
        
        startCryoInfusion()
    }
    
    private func startCryoInfusion() {
        withAnimation {
            isProcessing = true
            showSuccess = false
            showResults = false
        }
        
        // Simulate processing delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            generateResults()
            
            withAnimation {
                isProcessing = false
                showSuccess = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation {
                    showSuccess = false
                    showResults = true
                }
                showAlert(message: "Cryo infusion successful!", type: .success)
            }
        }
    }
    
    private func generateResults() {
        let stabilityBase = (Double(frostbiteFactor) ?? 5.0) * (Double(stabilizerConstant) ?? 1.0)
        let stabilityIndex = min(10.0, max(1.0, stabilityBase / 10.0))
        let duration = Double(iterations) * 0.8
        let energyAbsorption = abs(coreTemperature) * cryoRate * intensityMultiplier * (resonanceFrequency / 3.0)
        
        let params = """
        Ironhollow Frostshriek Configuration
        -----------------------------------
        Core Temperature: \(Int(coreTemperature))°K
        Cryo Rate: \(String(format: "%.1f", cryoRate)) mL/s
        Frostbite Factor: \(frostbiteFactor)
        Stabilizer Constant: \(stabilizerConstant)
        Iterations: \(iterations)
        Protocol: \(cryoProtocol.rawValue)
        Matrix: \(frostMatrix.rawValue)
        Intensity: \(intensityLevel.rawValue)
        Resonance: \(String(format: "%.1f", resonanceFrequency)) kHz
        """
        
        infusionResult = CryoResult(
            energyAbsorption: energyAbsorption,
            stabilityIndex: stabilityIndex,
            duration: duration,
            timestamp: Date(),
            parametersSnapshot: params
        )
    }
    
    private func resetForm() {
        withAnimation(.spring()) {
            coreTemperature = -50
            cryoRate = 2.5
            frostbiteFactor = ""
            stabilizerConstant = ""
            iterations = 1
            cryoProtocol = .glacial
            frostMatrix = .ice
            intensityLevel = .moderate
            resonanceFrequency = 3.0
            showSuccess = false
            showResults = false
            infusionResult = nil
        }
        showAlert(message: "Chamber reset to default parameters", type: .info)
    }
    
    private func showAlert(message: String, type: AlertType) {
        alertMessage = message
        alertType = type
        withAnimation(.spring()) {
            showAlert = true
        }
    }
    
    private func dismissAlert() {
        withAnimation(.spring()) {
            showAlert = false
        }
    }
    
    private func captureScreenshot() {
        let controller = UIHostingController(rootView: body)
        let view = controller.view
        
        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear
        
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        let image = renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
        
        capturedImage = image
        showShareSheet = true
    }
    
    private func copyResultsToClipboard() {
        UIPasteboard.general.string = resultShareText
        showAlert(message: "Cryo data copied", type: .success)
    }
    
    private func prepareShare() {
        if infusionResult != nil {
            showShareSheet = true
        }
    }
    
    private func showHelp() {
        showAlert(message: """
        Ironhollow Frostshriek Manual
        ----------------------------
        1. Set core temperature (-273°K to 0°K)
        2. Configure cryo injection rate
        3. Enter frostbite factor (1-100)
        4. Set stabilizer constant (0.1-10)
        5. Select protocol and matrix
        6. Adjust resonance frequency
        7. Initiate cryo infusion
        
        Warning: Extreme temperatures may cause quantum instability.
        """, type: .info)
    }
}
@available(iOS 15.0, *)
// MARK: - Components
struct FrostCardView<Content: View>: View {
    let title: String?
    let systemImage: String?
    let content: Content
    
    init(title: String? = nil, systemImage: String? = nil, @ViewBuilder content: () -> Content) {
        self.title = title
        self.systemImage = systemImage
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if let title = title {
                HStack {
                    if let systemImage = systemImage {
                        Image(systemName: systemImage)
                            .foregroundColor(.teal)
                    }
                    
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.primary)
                }
            }
            
            content
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: Color.blue.opacity(0.1), radius: 10, x: 0, y: 5)
        )
    }
}
@available(iOS 15.0, *)
struct FrostTextField: View {
    @Binding var value: String
    let label: String
    let symbol: String
    let keyboardType: UIKeyboardType
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: symbol)
                    .foregroundColor(.teal)
                
                Text(label)
                    .font(.headline)
            }
            
            TextField("Enter \(label)", text: $value)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(keyboardType)
                .submitLabel(.done)
        }
    }
}
@available(iOS 15.0, *)
struct FrostMenuPicker<T: Hashable & RawRepresentable>: View where T.RawValue == String {
    @Binding var selection: T
    let title: String
    let options: [T]
    
    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
            
            Spacer()
            
            Menu {
                Picker(selection: $selection, label: EmptyView()) {
                    ForEach(options, id: \.self) { option in
                        Text(option.rawValue).tag(option)
                    }
                }
            } label: {
                HStack {
                    Text(selection.rawValue)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                    
                    Image(systemName: "chevron.down")
                        .imageScale(.small)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color(.systemGray5))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
    }
}
@available(iOS 15.0, *)
struct FrostButton: View {
    let action: () -> Void
    let label: String
    let icon: String
    let color: Color
    var isLoading: Bool = false
    
    var body: some View {
        Button(action: action) {
            HStack {
                if isLoading {
                    ProgressView()
                        .tint(.white)
                } else {
                    Image(systemName: icon)
                }
                
                Text(label)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .foregroundColor(.white)
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .contentShape(Rectangle())
        }
        .buttonStyle(ScaleButtonStyle())
        .disabled(isLoading)
    }
}

struct FrostMetricView: View {
    let icon: String
    let label: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 24)
            
            Text(label)
                .font(.subheadline)
                .foregroundColor(.primary)
            
            Spacer()
            
            Text(value)
                .font(.body.monospacedDigit())
                .fontWeight(.medium)
        }
    }
}

struct FrostAlertView: View {
    @Binding var isPresented: Bool
    let title: String
    let message: String
    let type: AlertType
    
    var iconName: String {
        switch type {
        case .info: return "info.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .error: return "xmark.circle.fill"
        case .success: return "checkmark.circle.fill"
        }
    }
    
    var iconColor: Color {
        switch type {
        case .info: return .blue
        case .warning: return .yellow
        case .error: return .red
        case .success: return .green
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Image(systemName: iconName)
                    .foregroundColor(iconColor)
                    .font(.title)
                
                Text(title)
                    .font(.headline)
                
                Spacer()
                
                Button(action: { isPresented = false }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            
            Divider()
            
            Text(message)
                .font(.subheadline)
                .foregroundColor(.primary)
                .padding()
        }
        .frame(width: 300)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 10)
        .transition(.scale.combined(with: .opacity))
    }
}
@available(iOS 15.0, *)
struct ProcessingOverlay: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .teal))
                    .scaleEffect(2)
                
                Text("Stabilizing Cryo Matrix...")
                    .font(.headline)
                    .foregroundColor(.white)
            }
            .padding(40)
            .background(Color(.systemBackground))
            .cornerRadius(20)
            .shadow(radius: 10)
        }
        .transition(.opacity)
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.5), value: configuration.isPressed)
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: applicationActivities
        )
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

// MARK: - Data Models
enum AlertType {
    case info, warning, error, success
    
    var title: String {
        switch self {
        case .info: return "Information"
        case .warning: return "Warning"
        case .error: return "Error"
        case .success: return "Success"
        }
    }
}
@available(iOS 15.0, *)
struct CryoResult {
    let energyAbsorption: Double
    let stabilityIndex: Double
    let duration: TimeInterval
    let timestamp: Date
    let parametersSnapshot: String
    
    var shareableText: String {
        """
        Ironhollow Frostshriek Results
        -----------------------------
        Energy Absorption: \(String(format: "%.2f", energyAbsorption)) MW
        Stability Index: \(String(format: "%.1f", stabilityIndex))/10
        Duration: \(String(format: "%.1f", duration)) seconds
        
        Configuration:
        \(parametersSnapshot)
        
        Generated on \(timestamp.formatted())
        """
    }
}
@available(iOS 15.0,*)
struct IronhollowFrostshriekView_Previews: PreviewProvider {
    static var previews: some View {
        IronhollowFrostshriekView()
    }
}
