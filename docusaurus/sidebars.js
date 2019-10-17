/**
 * Copyright (c) 2017-present, Facebook, Inc.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */
const cmdlets = require('./docs/docusaurus.powershell.sidebar.js');

module.exports = {
  docs: {
    'Docusaurus.Powershell': ['installation', 'usage'],
    'FAQ': ['faq-monolithic', 'faq-edit-url'],
    CmdLets: cmdlets
  },
};
