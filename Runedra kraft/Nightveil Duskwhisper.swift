import SwiftUI
@available(iOS 15.0,*)
struct NightveilDuskwhisperView: View {
    // MARK: - Updated Enums
    enum InfusionType: String, CaseIterable {
        case basic = "Dusk Protocol"
        case enhanced = "Twilight Protocol"
        case quantum = "Nocturne Protocol"
        case singularity = "Eclipse Protocol"
    }
    
    enum MaterialType: String, CaseIterable {
        case alpha = "Lunar Matrix"
        case beta = "Stellar Composite"
        case gamma = "Celestial Alloy"
    }
    
    enum IntensityLevel: String, CaseIterable {
        case minimal = "Whisper"
        case moderate = "Murmur"
        case extreme = "Resonance"
    }
    
    // MARK: - State Variables
    @State private var coreValue: Double = 50
    @State private var infusionRate: Double = 2.5
    @State private var plinthrideFactor: String = ""
    @State private var stabilizerConstant: String = ""
    @State private var iterations: Int = 1
    @State private var infusionType: InfusionType = .basic
    @State private var materialType: MaterialType = .alpha
    @State private var intensityLevel: IntensityLevel = .moderate
    @State private var showSuccess = false
    @State private var showResults = false
    @State private var infusionResult: InfusionResult?
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var alertType: AlertType = .info
    @State private var capturedImage: UIImage?
    @State private var showShareSheet = false
    @State private var sparkleFrequency: Double = 3.0
    
    // MARK: - Main View
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 20) {
                    headerView
                    parametersSection
                    
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
                if let image = capturedImage {
                    ActivityView(activityItems: [image, resultShareText])
                } else if let result = infusionResult {
                    ActivityView(activityItems: [result.shareableText])
                }
            }
            
            // Alert overlay
            if showAlert {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .transition(.opacity)
                    .onTapGesture {
                        withAnimation {
                            showAlert = false
                        }
                    }
                
                CustomAlertView(
                    isPresented: $showAlert,
                    title: alertType.title,
                    message: alertMessage,
                    type: alertType
                )
                .transition(.scale.combined(with: .opacity))
                .zIndex(1)
            }
        }
    }
    
    // MARK: - Subviews
    private var backgroundGradient: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color(.systemIndigo).opacity(0.2), Color(.systemPurple).opacity(0.2)]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Nightveil Duskwhisper")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.indigo)
                
                Text("Quantum resonance modulation system")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Menu {
                Button(action: captureScreenshot) {
                    Label("Capture Essence", systemImage: "camera.fill")
                }
                
                if infusionResult != nil {
                    Button(action: copyResultsToClipboard) {
                        Label("Copy Echoes", systemImage: "doc.on.doc.fill")
                    }
                    
                    Button(action: prepareShare) {
                        Label("Share Resonance", systemImage: "square.and.arrow.up")
                    }
                }
                
                Button(action: showHelp) {
                    Label("Eldritch Guide", systemImage: "questionmark.circle")
                }
            } label: {
                Image(systemName: "ellipsis.circle.fill")
                    .font(.title2)
                    .foregroundColor(.purple)
            }
        }
        .padding(.bottom, 20)
    }
    
    private var parametersSection: some View {
        CardView(title: "Resonance Parameters", tag: 1) {
            // Core Value as Stars
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "moon.stars.fill")
                        .foregroundColor(.purple)
                    
                    Text("Core Luminescence")
                        .font(.headline)
                    
                    Spacer()
                }
                
                if #available(iOS 15.0, *) {
                    SparkleFrequencyControl(
                        value: $coreValue,
                        range: 1...100,
                        label: "Core Luminescence",
                        symbol: "moon.stars.fill",
                        color: .purple
                    )
                    .padding(.vertical, 8)
                } else {
                    Slider(value: $coreValue, in: 1...100, step: 1)
                        .tint(.purple)
                    Text("\(Int(coreValue))")
                        .font(.subheadline)
                        .foregroundColor(.purple)
                }
                configurationSection
            }
            
            // Infusion Rate as Stars
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "timelapse")
                        .foregroundColor(.indigo)
                    
                    Text("Duskwave Frequency")
                        .font(.headline)
                    
                    Spacer()
                }
                
                if #available(iOS 15.0, *) {
                    SparkleFrequencyControl(
                        value: $infusionRate,
                        range: 0.1...5,
                        label: "Duskwave Frequency",
                        symbol: "timelapse",
                        color: .indigo
                    )
                    .padding(.vertical, 8)
                } else {
                    Slider(value: $infusionRate, in: 0.1...5, step: 0.1)
                        .tint(.indigo)
                    Text("\(infusionRate, specifier: "%.1f")")
                        .font(.subheadline)
                        .foregroundColor(.indigo)
                }
            }
            
            ParameterTextField(value: $plinthrideFactor, label: "Shadow Coefficient", symbol: "function")
            
            ParameterTextField(value: $stabilizerConstant, label: "Twilight Constant", symbol: "ruler")
            
            HStack {
                Text("Echo Iterations: \(iterations)")
                    .font(.headline)
                
                Spacer()
                
                Button(action: {
                    withAnimation {
                        iterations += 1
                    }
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                }
                .buttonStyle(BouncyButtonStyle())
            }
            .padding(.vertical, 8)
        }
    }
    
    private var configurationSection: some View {
        CardView(title: "Nocturne Configuration", tag: 2) {
            MenuPickerView(selection: $infusionType, title: "Dusk Protocol", options: InfusionType.allCases)
            
            MenuPickerView(selection: $materialType, title: "Celestial Matrix", options: MaterialType.allCases)
            
            VStack {
                Text("Resonance Intensity")
                    .font(.headline)
                
                Spacer()
                
                HStack(spacing: 0) {
                    ForEach(IntensityLevel.allCases, id: \.self) { level in
                        Button(action: {
                            withAnimation {
                                intensityLevel = level
                            }
                        }) {
                            Text(level.rawValue)
                                .font(.subheadline)
                                .padding(8)
                                .frame(width: 100)
                                .background(intensityLevel == level ? Color.purple : Color.clear)
                                .foregroundColor(intensityLevel == level ? .white : .primary)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }
                }
                .background(Color(.systemGray5))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
    }
    
    private var actionButtons: some View {
        HStack {
            Button(action: validateAndStartInfusion) {
                HStack {
                    Image(systemName: "sparkles")
                    Text("Begin Nocturne")
                }
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(BouncyButtonStyle(backgroundColor: .purple))
            
            Button(action: resetForm) {
                HStack {
                    Image(systemName: "moon.zzz.fill")
                    Text("Reset Veil")
                }
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(BouncyButtonStyle(backgroundColor: .indigo))
        }
    }
    
    private var successView: some View {
        CardView {
            VStack {
                Image(systemName: "sparkles")
                    .font(.system(size: 60))
                    .foregroundColor(.purple)
                
                Text("Nocturne Complete!")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.purple)
            }
            .frame(maxWidth: .infinity)
        }
        .transition(.scale.combined(with: .opacity))
    }
    
    private func resultsSection(result: InfusionResult) -> some View {
        CardView(title: "Duskwhisper Echoes", tag: 2) {
            VStack(alignment: .leading, spacing: 15) {
                HStack {
                    Text("Resonance Echoes")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation {
                            showResults = false
                        }
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                }
                
                ResultRow(icon: "bolt.fill", label: "Luminous Output", value: "\(String(format: "%.2f", result.energyOutput)) MW", color: .yellow)
                
                ResultRow(icon: "waveform.path.ecg", label: "Harmony Index", value: "\(String(format: "%.1f", result.stabilityIndex))/10", color: result.stabilityIndex > 7 ? .green : result.stabilityIndex > 4 ? .orange : .red)
                
                ResultRow(icon: "clock.fill", label: "Dusk Duration", value: "\(String(format: "%.1f", result.duration)) sec", color: .blue)
                
                ResultRow(icon: "calendar", label: "Moon Phase", value: result.timestamp.formatted(), color: .secondary)
                
                Divider()
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Celestial Guidance")
                        .font(.headline)
                    
                    if result.stabilityIndex < 5 {
                        Text("• Increase twilight constant")
                        Text("• Reduce duskwave frequency by 10-15%")
                        Text("• Consider using Stellar Composite")
                    } else if result.energyOutput < 50 {
                        Text("• Increase core luminescence")
                        Text("• Try Nocturne Protocol")
                        Text("• Consider Resonance intensity")
                    } else {
                        Text("• Parameters are harmonious")
                        Text("• Consider increasing echo iterations")
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray6)))
            }
        }
    }
    
    // MARK: - Helper Components
    struct CardView<Content: View>: View {
        let title: String?
        let content: Content
        let tag: Int?
        
        init(title: String? = nil, tag: Int? = nil, @ViewBuilder content: () -> Content) {
            self.title = title
            self.tag = tag
            self.content = content()
        }
        
        var body: some View {
            VStack(alignment: .leading, spacing: 15) {
                if let title = title {
                    Text(title)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                        .padding(.bottom, 5)
                }
                
                content
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 15).fill(background))
            .shadow(color: Color.primary.opacity(0.1), radius: 10, x: 0, y: 5)
        }
        
        var background: Color {
            switch tag {
            case 1:
                return Color.purple.opacity(0.2)
            case 2:
                return Color.indigo.opacity(0.2)
            default:
                return Color.white.opacity(0.4)
            }
        }
    }
    
    struct ResultRow: View {
        let icon: String
        let label: String
        let value: String
        let color: Color
        
        var body: some View {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .frame(width: 30)
                
                Text(label)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Text(value)
                    .font(.body.monospacedDigit())
                    .fontWeight(.medium)
            }
            .padding(.vertical, 4)
        }
    }
    
    struct ParameterSliderView: View {
        @Binding var value: Double
        let range: ClosedRange<Double>
        let label: String
        let symbol: String
        
        var body: some View {
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: symbol)
                        .foregroundColor(.purple)
                    
                    Text(label)
                        .font(.headline)
                    
                    Spacer()
                    
                    Text("\(value, specifier: "%.1f")")
                        .font(.headline.monospacedDigit())
                        .foregroundColor(.purple)
                }
                
                Slider(value: $value, in: range, step: 0.1)
                    .tint(.purple)
                    .padding(.top, 4)
            }
        }
    }
    
    struct ParameterTextField: View {
        @Binding var value: String
        let label: String
        let symbol: String
        var keyboardType: UIKeyboardType = .decimalPad
        
        var body: some View {
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: symbol)
                        .foregroundColor(.indigo)
                    
                    Text(label)
                        .font(.headline)
                }
                
                TextField("Enter \(label)", text: $value)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(keyboardType)
                    .padding(.top, 4)
            }
        }
    }
    
    struct MenuPickerView<T: Hashable & RawRepresentable>: View where T.RawValue == String {
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
                        Image(systemName: "chevron.down")
                            .scaleEffect(0.8)
                    }
                    .padding(8)
                    .padding(.horizontal, 4)
                    .background(Color(.systemGray5))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
    
    struct BouncyButtonStyle: ButtonStyle {
        var backgroundColor: Color = .purple
        var foregroundColor: Color = .white
        
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .font(.headline)
                .foregroundColor(foregroundColor)
                .padding()
                .background(backgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
                .opacity(configuration.isPressed ? 0.9 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.5), value: configuration.isPressed)
        }
    }
    
    struct CustomAlertView: View {
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
            VStack {
                HStack {
                    Image(systemName: iconName)
                        .foregroundColor(iconColor)
                        .font(.title)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(title)
                            .font(.headline)
                        Text(message)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation {
                            isPresented = false
                        }
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(10)
                .shadow(radius: 10)
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation {
                        isPresented = false
                    }
                }
            }
        }
    }
    
    @available(iOS 15.0, *)
    struct SparkleFrequencyControl: View {
        @Binding var value: Double
        var range: ClosedRange<Double>
        var label: String = ""
        var symbol: String = "star.fill"
        var color: Color = .purple
        
        private let maxStars = 5
        private let starSize: CGFloat = 30
        private let starSpacing: CGFloat = 8
        
        private var normalizedValue: Int {
            let valueRange = range.upperBound - range.lowerBound
            let normalized = (value - range.lowerBound) / valueRange
            return Int(round(normalized * Double(maxStars - 1)))
        }
        
        private var formattedValue: String {
            if range.lowerBound == 1 && range.upperBound == 100 {
                return String(format: "%.0f", value)
            } else {
                return String(format: "%.1f", value)
            }
        }
        
        private var unit: String {
            if label == "Core Luminescence" {
                return " lumens"
            } else if label == "Duskwave Frequency" {
                return " kHz"
            } else {
                return ""
            }
        }
        
        var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: symbol)
                        .foregroundColor(color)
                    Text(label.uppercased())
                        .font(.custom("Chalkboard SE", size: 16))
                }
                .foregroundColor(color)
                
                HStack(spacing: starSpacing) {
                    ForEach(0..<maxStars, id: \.self) { index in
                        starView(index: index)
                    }
                }
                .frame(height: starSize * 1.5)
                
                Text("\(formattedValue)\(unit)")
                    .font(.custom("Chalkboard SE", size: 16).bold())
                    .foregroundColor(color)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 4)
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(color.opacity(0.5), lineWidth: 1.5)
            )
        }
        
        private func starView(index: Int) -> some View {
            let isActive = index <= normalizedValue
            let scale: CGFloat = index == normalizedValue ? 1.3 : 1.0
            
            return Image(systemName: "star.fill")
                .font(.system(size: starSize))
                .foregroundColor(isActive ? color : color.opacity(0.3))
                .scaleEffect(scale)
                .overlay(starOverlay(isActive: index == normalizedValue))
                .onTapGesture {
                    updateValue(for: index)
                }
        }
        
        private func starOverlay(isActive: Bool) -> some View {
            Group {
                if isActive {
                    Circle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: starSize * 1.8, height: starSize * 1.8)
                        .blur(radius: 2)
                        .transition(.opacity)
                }
            }
        }
        
        private func updateValue(for index: Int) {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                let stepSize = (range.upperBound - range.lowerBound) / Double(maxStars - 1)
                value = range.lowerBound + stepSize * Double(index)
            }
        }
    }
    
    struct ActivityView: UIViewControllerRepresentable {
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
            case .info: return "Whisper"
            case .warning: return "Caution"
            case .error: return "Disturbance"
            case .success: return "Harmony"
            }
        }
    }
    
    struct InfusionResult {
        let energyOutput: Double
        let stabilityIndex: Double
        let duration: TimeInterval
        let timestamp: Date
        let parametersSnapshot: String
        
        var shareableText: String {
            """
            Nightveil Duskwhisper Echoes
            ---------------------------
            Luminous Output: \(String(format: "%.2f", energyOutput)) MW
            Harmony Index: \(String(format: "%.1f", stabilityIndex))/10
            Dusk Duration: \(String(format: "%.1f", duration)) seconds
            
            Celestial Configuration:
            \(parametersSnapshot)
            
            Recorded during \(timestamp.formatted())
            """
        }
    }
    
    // MARK: - Actions and Functions
    private var resultShareText: String {
        guard let result = infusionResult else { return "" }
        return result.shareableText
    }
    
    private var intensityMultiplier: Double {
        switch intensityLevel {
        case .minimal: return 0.7
        case .moderate: return 1.0
        case .extreme: return 1.8
        }
    }
    
    private func validateAndStartInfusion() {
        guard !plinthrideFactor.isEmpty else {
            showAlert(message: "Please enter Shadow Coefficient", type: .warning)
            return
        }
        
        guard !stabilizerConstant.isEmpty else {
            showAlert(message: "Please enter Twilight Constant", type: .warning)
            return
        }
        
        startInfusion()
    }
    
    private func startInfusion() {
        showSuccess = false
        showResults = false
        
        let stabilityBase = (Double(plinthrideFactor) ?? 5.0) * (Double(stabilizerConstant) ?? 1.0)
        let stabilityIndex = min(10.0, max(1.0, stabilityBase / 10.0))
        let duration = Double(iterations) * 0.5
        let energyOutput = Double(coreValue) * Double(infusionRate) * intensityMultiplier * (sparkleFrequency / 3.0)
        
        let params = """
        Sparkle Frequency: \(String(format: "%.1f", sparkleFrequency)) kHz
        Core Luminescence: \(Int(coreValue)) lumens
        Duskwave Frequency: \(String(format: "%.1f", infusionRate)) kHz
        Shadow Coefficient: \(plinthrideFactor)
        Twilight Constant: \(stabilizerConstant)
        Echo Iterations: \(iterations)
        Dusk Protocol: \(infusionType.rawValue)
        Celestial Matrix: \(materialType.rawValue)
        Resonance: \(intensityLevel.rawValue)
        """
        
        infusionResult = InfusionResult(
            energyOutput: energyOutput,
            stabilityIndex: stabilityIndex,
            duration: duration,
            timestamp: Date(),
            parametersSnapshot: params
        )
        
        withAnimation {
            showSuccess = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation {
                showSuccess = false
                showResults = true
            }
            showAlert(message: "Nocturne resonance achieved!", type: .success)
        }
    }
    
    private func resetForm() {
        withAnimation {
            coreValue = 50
            infusionRate = 2.5
            plinthrideFactor = ""
            stabilizerConstant = ""
            iterations = 1
            infusionType = .basic
            materialType = .alpha
            intensityLevel = .moderate
            showSuccess = false
            showResults = false
            infusionResult = nil
        }
        showAlert(message: "Veil restored to twilight state", type: .info)
    }
    
    private func showAlert(message: String, type: AlertType) {
        withAnimation {
            alertMessage = message
            alertType = type
            showAlert = true
        }
    }
    
    private func captureScreenshot() {
        let controller = UIHostingController(rootView: self.body)
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
        showAlert(message: "Essence captured!", type: .success)
    }
    
    private func copyResultsToClipboard() {
        UIPasteboard.general.string = resultShareText
        showAlert(message: "Echoes copied to scroll", type: .success)
    }
    
    private func prepareShare() {
        if infusionResult != nil {
            showShareSheet = true
        }
    }
    
    private func showHelp() {
        showAlert(message: """
        Eldritch Guide:
        1. Set all celestial parameters
        2. Configure nocturne settings
        3. Begin the duskwhisper
        4. Interpret the resonance echoes
        """, type: .info)
    }
}

@available(iOS 15.0,*)
struct NightveilDuskwhisperView_Previews: PreviewProvider {
    static var previews: some View {
        NightveilDuskwhisperView()
    }
}
