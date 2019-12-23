/**
 * Copyright (c) 2017-present, Facebook, Inc.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */
const commands = require('./docs/commands/docusaurus.sidebar.js');

module.exports = {
  docs: {
    'Docusaurus.Powershell': [
      'introduction',
      'installation',
      'usage'
    ],
    'F.A.Q.': [
      'faq/multiple-modules',
      'faq/monolithic-modules',
      'faq/search',
      'faq/ci-cd',
    ],
    "Command Reference": commands,
  },
};
