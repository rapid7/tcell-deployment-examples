resource "tcell_app" "my-app" {
  name = "Terraform app"
}

resource "tcell_features" "my-app-features" {
  app_id = "${tcell_app.my-app.id}"
  appfirewall = true
  csp = "Block"
  jsconfig = true
  httpredirect = "Block"
  login = false
}

resource "tcell_config" "my-app-appfirewall" {
  app_id = "${tcell_app.my-app.id}"
  type = "appfirewall"
  config = <<CONFIG
{
  "appFwVersion": 4,
  "notes": {
    "excludedRoutes": {}
  },
  "payloads": {
    "logLocally": {
      "blacklist": [
        "token",
        "client_secret",
        "password",
        "passwd",
        "refresh_token",
        "pf.pass",
        "user.password",
        "j_password",
        "password",
        "pwd",
        "j_sessionid",
        "sessionid",
        "session",
        "token",
        "csrftoken",
        "passwd",
        "refresh_token",
        "user.password",
        "jsessionid"
      ],
      "enabled": false,
      "whitelist": []
    },
    "sendToTcell": {
      "blacklist": [
        "token",
        "client_secret",
        "password",
        "passwd",
        "refresh_token",
        "pf.pass",
        "user.password",
        "j_password",
        "password",
        "pwd",
        "j_sessionid",
        "sessionid",
        "session",
        "token",
        "csrftoken",
        "passwd",
        "refresh_token",
        "user.password",
        "jsessionid"
      ],
      "enabled": true,
      "whitelist": []
    }
  },
  "sensors": {
    "cmdi": {
      "enabled": true,
      "patterns": [
        "tc-cmdi-1",
        "tc-cmdi-2",
        "tc-cmdi-3"
      ]
    },
    "databaseResultSize": {
      "enabled": false,
      "limit": 0,
      "patterns": []
    },
    "errors": {
      "csrfException": true,
      "enabled": true,
      "patterns": [],
      "sqlException": true
    },
    "fpt": {
      "enabled": true,
      "patterns": [
        "tc-fpt-1",
        "tc-fpt-2",
        "tc-fpt-3",
        "tc-fpt-4"
      ]
    },
    "nullbyte": {
      "enabled": true,
      "patterns": [
        "tc-nullbyte-1"
      ]
    },
    "requestSize": {
      "enabled": true,
      "limit": 7168,
      "patterns": []
    },
    "responseCodes": {
      "enabled": true,
      "patterns": [],
      "s400Series": true,
      "s500Series": true
    },
    "retr": {
      "enabled": true,
      "patterns": [
        "tc-retr-1"
      ]
    },
    "responseSize": {
      "enabled": true,
      "limit": 20480,
      "patterns": []
    },
    "sqli": {
      "enabled": true,
      "libinjection": true,
      "patterns": [
        "tc-sqli-4",
        "tc-sqli-2",
        "tc-sqli-7",
        "tc-sqli-3",
        "tc-sqli-1"
      ]
    },
    "ua": {
      "enabled": true,
      "patterns": [],
      "userAgentEmpty": true
    },
    "xss": {
      "enabled": true,
      "libinjection": true,
      "patterns": [
        "tc-xss-2",
        "tc-xss-8",
        "tc-xss-6",
        "tc-xss-7",
        "tc-xss-4",
        "tc-xss-1",
        "tc-xss-5"
      ]
    }
  },
  "uriOptions": {
    "collectFullUri": true
  },
  "v1Toggles": {
    "options": {
      "cmdi": true,
      "fpt": true,
      "loginFailure": true,
      "null": true,
      "reqResSize": true,
      "respCodes": true,
      "retr": true,
      "sqli": true,
      "xss": true
    }
  },
  "version": 1
}
CONFIG
}

resource "tcell_config" "my-csp" {
  app_id = "${tcell_app.my-app.id}"
  type = "csp"

  config = <<CONFIG
{
  "directives": [
    {
      "directive": "font-src",
      "source": "'self'"
    },
    {
      "directive": "script-src",
      "source": "'self'"
    },
    {
      "directive": "frame-src",
      "source": "'none'"
    },
    {
      "directive": "style-src",
      "source": "'self'"
    },
    {
      "directive": "style-src",
      "source": "css.example.com"
    },
    {
      "directive": "connect-src",
      "source": "'self'"
    },
    {
      "directive": "img-src",
      "source": "'self'"
    },
    {
      "directive": "object-src",
      "source": "'none'"
    },
    {
      "directive": "script-src",
      "source": "'unsafe-eval'"
    },
    {
      "directive": "style-src",
      "source": "'unsafe-eval'"
    },
    {
      "directive": "manifest-src",
      "source": "'none'"
    },
    {
      "directive": "media-src",
      "source": "'none'"
    },
    {
      "directive": "worker-src",
      "source": "'none'"
    },
    {
      "directive": "script-src",
      "source": "'unsafe-inline'"
    },
    {
      "directive": "style-src",
      "source": "'unsafe-inline'"
    },
    {
      "directive": "script-src",
      "source": "jsagent.tcell-preview.io"
    },
    {
      "directive": "connect-src",
      "source": "https://api.tcell.io/"
    },
    {
      "directive": "connect-src",
      "source": "https://input.tcell-preview.io/"
    },
    {
      "directive": "frame-src",
      "source": "https://input.tcell-preview.io/"
    }
  ],
  "pathRules": [],
  "version": 2
}
CONFIG
}

resource "tcell_app" "release" {
  name = "Release"
}

data "tcell_config" "srcConfig" {
  app_id = "${tcell_app.my-app.id}"

  /*depends_on = [
    "tcell_features.my-app-features",
    "tcell_config.my-app-appfirewall"
  ] gives very strange error looking at app for destAppId */
}

data "tcell_config" "destConfig" {
  app_id = "${tcell_app.release.id}"
}

resource "tcell_config_clone" "clone2relese" {
  source_app_id = "${tcell_app.my-app.id}"
  destination_app_id = "${tcell_app.release.id}"

  source_cfg_id = "${data.tcell_config.srcConfig.id}"
}