.pragma library

.import "./deps/oauth-1.0a.js" as OAuth
.import "./deps/cross-fetch.js" as Fetch
.import "./deps/crypto-js.js" as CryptoJS
.import "./deps/querystring.js" as Querystring;

const getUrl = (subdomain, endpoint = '1.1') =>
  `https://${subdomain}.twitter.com/${endpoint}`;

const createOauthClient = ({ key, secret }) => {
  const client = OAuth.oauth10a({
    consumer: { key, secret },
    signature_method: 'HMAC-SHA1',
    hash_function(baseString, key) {
      return new CryptoJS.HmacSHA1(baseString, key).toString(CryptoJS.enc.Base64);
    },
  });

  return client;
};

const defaults = {
  subdomain: 'api',
  consumer_key: null,
  consumer_secret: null,
  access_token_key: null,
  access_token_secret: null,
  bearer_token: null,
  version: '1.1',
};

// Twitter expects POST body parameters to be URL-encoded: https://developer.twitter.com/en/docs/basics/authentication/guides/creating-a-signature
// However, some endpoints expect a JSON payload - https://developer.twitter.com/en/docs/direct-messages/sending-and-receiving/api-reference/new-event
// It appears that JSON payloads don't need to be included in the signature,
// because sending DMs works without signing the POST body
const JSON_ENDPOINTS = [
  'direct_messages/events/new',
  'direct_messages/welcome_messages/new',
  'direct_messages/welcome_messages/rules/new',
  'media/metadata/create',
  'collections/entries/curate',
];

const baseHeaders = {
  'Content-Type': 'application/json',
  Accept: 'application/json',
};

function percentEncode(string) {
  // From OAuth.prototype.percentEncode
  return string
    .replace(/!/g, '%21')
    .replace(/\*/g, '%2A')
    .replace(/'/g, '%27')
    .replace(/\(/g, '%28')
    .replace(/\)/g, '%29');
}

class Twitter {
  constructor(options) {
    const config = Object.assign({}, defaults, options);
    this.authType = config.bearer_token ? 'App' : 'User';
    this.client = createOauthClient({
      key: config.consumer_key,
      secret: config.consumer_secret,
    });

    this.token = {
      key: config.access_token_key,
      secret: config.access_token_secret,
    };

    this.url = getUrl(config.subdomain, config.version);
    this.oauth = getUrl(config.subdomain, 'oauth');
    this.config = config;
  }

  /**
   * Construct the data and headers for an authenticated HTTP request to the Twitter API
   * @param {string} method - 'GET' or 'POST'
   * @param {string} resource - the API endpoint
   * @param {object} parameters
   * @return {{requestData: {url: string, method: string}, headers: ({Authorization: string}|OAuth.Header)}}
   * @private
   */
  _makeRequest(method, resource, parameters) {
    const requestData = {
      url: `${this.url}/${resource}.json`,
      method,
    };
    if (parameters)
      if (method === 'POST') requestData.data = parameters;
      else requestData.url += '?' + Querystring.stringify(parameters);

    let headers = {};
    if (this.authType === 'User') {
      headers = this.client.toHeader(
        this.client.authorize(requestData, this.token),
      );
    } else {
      headers = {
        Authorization: `Bearer ${this.config.bearer_token}`,
      };
    }
    return {
      requestData,
      headers,
    };
  }

  /**
   * Send a GET request
   * @param {string} resource - endpoint, e.g. `followers/ids`
   * @param {object} [parameters] - optional parameters
   * @returns {Promise<object>} Promise resolving to the response from the Twitter API.
   *   The `_header` property will be set to the Response headers (useful for checking rate limits)
   */
  get(resource, parameters) {
    const { requestData, headers } = this._makeRequest(
      'GET',
      resource,
      parameters,
    );

    return Fetch.crossFetch(requestData.url, { headers })
      .then(Twitter._handleResponse);
  }

  /**
   * Send a POST request
   * @param {string} resource - endpoint, e.g. `users/lookup`
   * @param {object} body - POST parameters object.
   *   Will be encoded appropriately (JSON or urlencoded) based on the resource
   * @returns {Promise<object>} Promise resolving to the response from the Twitter API.
   *   The `_header` property will be set to the Response headers (useful for checking rate limits)
   */
  post(resource, body) {
    const { requestData, headers } = this._makeRequest(
      'POST',
      resource,
      JSON_ENDPOINTS.includes(resource) ? null : body, // don't sign JSON bodies; only parameters
    );

    const postHeaders = Object.assign({}, baseHeaders, headers);
    if (JSON_ENDPOINTS.includes(resource)) {
      body = JSON.stringify(body);
    } else {
      body = percentEncode(Querystring.stringify(body));
      postHeaders['Content-Type'] = 'application/x-www-form-urlencoded';
    }

    return Fetch.crossFetch(requestData.url, {
      method: 'POST',
      headers: postHeaders,
      body,
    })
      .then(Twitter._handleResponse);
  }

  /**
   * Send a PUT request
   * @param {string} resource - endpoint e.g. `direct_messages/welcome_messages/update`
   * @param {object} parameters - required or optional query parameters
   * @param {object} body - PUT request body
   * @returns {Promise<object>} Promise resolving to the response from the Twitter API.
   */
  put(resource, parameters, body) {
    const { requestData, headers } = this._makeRequest(
      'PUT',
      resource,
      parameters,
    );

    const putHeaders = Object.assign({}, baseHeaders, headers);
    body = JSON.stringify(body);

    return Fetch.crossFetch(requestData.url, {
      method: 'PUT',
      headers: putHeaders,
      body,
    })
      .then(Twitter._handleResponse);
  }
}
