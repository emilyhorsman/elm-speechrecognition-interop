;
(function() {
    var SpeechRecognition = SpeechRecognition || webkitSpeechRecognition
    var SpeechGrammarList = SpeechGrammarList || webkitSpeechGrammarList
    var SpeechRecognitionEvent = SpeechRecognitionEvent || webkitSpeechRecognitionEvent

    if (typeof window.SpeechRecognitionInterop !== 'undefined') {
        console.warn('window.SpeechRecognitionInterop already populated')
        return
    }

    var module = {}
    module.createGrammar = function(words, weight) {
        var definition = '#JSGF V1.0; grammar words; public <word> = ' + words.join(' | ') + ';'
        var grammarList = new SpeechGrammarList()
        grammarList.addFromString(definition, weight || 1)
        return grammarList
    }

    module.translateResults = function(results) {
        // Have to do this because the SpeechRecognitionResultList is only
        // "Array-like" and does not have a map function
        var translated = []
        for (var resultIndex = 0; resultIndex < event.results.length; resultIndex++) {
            var result = event.results[resultIndex]
            var items = []
            for (var alternativeIndex = 0; alternativeIndex < result.length; alternativeIndex++) {
                items.push({
                    confidence: result[alternativeIndex].confidence,
                    transcript: result[alternativeIndex].transcript,
                })
            }

            translated.push({
                isFinal: result.isFinal,
                items: items,
            })
        }

        console.log('translated', translated)
        return translated
    }

    module.handleEvent = function(callback, event) {
        if (event.results.length === 0) {
            return
        }

        callback({
            resultIndex: event.resultIndex,
            results: module.translateResults(event.results),
        })
    }

    module.start = function(callback, opts) {
        var attrs = Object.assign({
            continuous: true,
            lang: 'en-US',
            interimResults: true,
        }, opts)

        var recognition = new SpeechRecognition()

        Object.keys(attrs).forEach(function(key) {
            recognition[key] = attrs[key]
        })

        recognition.addEventListener(
            'result',
            module.handleEvent.bind(null, callback)
        )
        recognition.start()
        return recognition
    }

    window.SpeechRecognitionInterop = module
})();
