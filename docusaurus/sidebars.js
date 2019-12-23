/**
 * Copyright (c) 2017-present, Facebook, Inc.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */
const faq = require('./docs/faq/docusaurus.sidebar.js');
const commands = require('./docs/commands/docusaurus.sidebar.js');

module.exports = {
  docs: {
    'Docusaurus.Powershell': ['introduction', 'installation', 'usage'],
    'F.A.Q.': faq,
    "Command Reference": commands,
  },
};
