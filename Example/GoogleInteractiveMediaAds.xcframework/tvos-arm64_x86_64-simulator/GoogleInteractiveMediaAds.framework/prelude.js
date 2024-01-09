// TODO (b/138857444) Add BUILD file to compile this file.

/**
 * Adapter for JSTimer.setTimeout implementation to allow for proper
 * propagation of variadic arguments.
 *
 * @param {function(...)} func The function to invoke.
 * @param {number} delay The amount of milliseconds to wait before invoking the
 *     function.
 * @param {...} args The arguments to pass to the function.
 * @return {number} The identifier for the timer.
 */
setTimeout = function(func, delay, ...args) {
  return JSTimer.setTimeout(func, delay, args);
};

/**
 * Cancel invocation scheduled by setTimeout (If not yet triggered).
 *
 * @param {number} id The ID returned by setTimeout
 *     for the invocation to cancel.
 */
clearTimeout = function(id) {
  JSTimer.clearTimeout(id);
};

/**
 * Sends a message from the native bridge to Obj-C.
 *
 * @param {string} name The message name.
 * @param {!Object} messageData The message data.
 */
browserlessSender = function(name, messageData) {
  IMAJSMessageReceiver.didReceiveMessage(name, messageData);
};

/**
 * Sends a message from Obj-c to the native bridge.
 *
 * @param {string} name The message name.
 * @param {!Object} messageData The message data.
 */
browserlessReceiver = function(name, messageData) {
  google.ima.NativeBridge.receiveMessage(name, JSON.stringify(messageData));
};

google = {};
google.ima = {};
google.ima.NativeLoader = {};
google.ima.BrowserlessExports = {};

/**
 * Sends a message from Obj-c to the native bridge.
 *
 * @param {string} text the text to be encrypted.
 * @param {string} keyset the keyset to be loaded.
 * @param {function(string)} callback function to be called with the encryption
 *     result.
 */
google.ima.BrowserlessExports.encryptString = function(text, keyset, callback) {
  JSEncryptor.encryptStringWithKeyset(text, keyset, callback);
};


/**
 * Gets the type of messaging that will be used to send messages from the JS
 * layer to the native layer of the SDK. Messaging types defined in:
 * javascript/ads/interactivemedia/sdk/native_bridge/constants.js
 *
 * @return {number} The type of messaging used (browserless).
 */
google.ima.NativeLoader.getMessagingType = function() {
  return 3;
};

// Used for platform checks in the native bridge.
navigator = {};

document = {};
/**
 * Temporary stub for getElementsByTagName.
 * TODO (kpshay) Remove once bridged document func is complete.
 * @return {!Array<!Object>} An empty array.
 */
document.getElementsByTagName = function() {
  return [];
};
window = {};
window.location = {};
window.location.search = '';
window.location.hash = '';
window.location.username = '';
window.location.password = '';
window.location.port = '';
window.document = document;
// Simulate a top window context.
window.parent = window;

/** A namespace for IMAXMLHttpRequest facilities. */
IMAXMLHttpRequest = {
  /**
   * A map for holding onto active XMLHttpRequests. This is needed so that the
   * garbage collector is aware of the XMLHttpRequest and won't deallocate its
   * JS members (for example, any event listeners added). See b/154539920 for
   * more details.
   * @const {!Map<string, !XMLHttpRequest>}
   */
  instances_: new Map(),

  /**
   * Retains the given XMLHttpRequest in JavaScript. This should be called once
   * the request is active and should not be garbage collected, even if there
   * are no other explicit references kept to it in JavaScript.
   * @param {!XMLHttpRequest} xhr The instance to register.
   * @param {string} id An unique ID for this instance.
   */
  retainInstance: function(xhr, id) {
    IMAXMLHttpRequest.instances_.set(id, xhr);
  },

  /**
   * Releases the given XMLHttpRequest in JavaScript. This should be called once
   * the request is no longer in an active state and can be garbage collected.
   * @param {string} id The ID of the XMLHttpRequest to release.
   */
  releaseInstance: function(id) {
    IMAXMLHttpRequest.instances_.delete(id);
  },
};
