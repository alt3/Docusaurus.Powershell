/**
 * Copyright (c) 2017-present, Facebook, Inc.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

module.exports = {
  title: 'Docusaurus.Powershell',
  tagline: 'Documentation websites for PowerShell Modules',
  url: 'https://docusaurus-powershell.vercel.app/',
  baseUrl: '/',
  favicon: 'img/favicon.ico',
  organizationName: 'alt3', // Usually your GitHub org/user name.
  projectName: 'Docusaurus.Powershell', // Usually your repo name.
  onBrokenLinks: 'warn',
  onBrokenMarkdownLinks: 'warn',
  themeConfig: {
    navbar: {
      title: 'Docusaurus.Powershell',
      logo: {
        alt: 'My Site Logo',
        src: 'img/logo.svg',
      },
      items: [
        { to: 'docs/introduction', label: 'Docs', position: 'right' },
        { to: 'docs/commands/New-DocusaurusHelp', label: 'Commands', position: 'right' },
        {
          href: 'https://github.com/alt3/Docusaurus.Powershell',
          label: 'GitHub',
          position: 'right',
        },
      ],
    },
    prism: {
      additionalLanguages: ['powershell'],
    },
    algolia: {
      appId: 'J6HI8PLPVO',
      apiKey: '7da5313674c5bdc00c7af45eda989ae2',
      indexName: 'docusaurus-powershell',
      algoliaOptions: {}, // Optional, if provided by Algolia
    },
    footer: {
      style: 'dark',
      links: [
        {
          title: 'Docs',
          items: [
            {
              label: 'Introduction',
              to: 'docs/introduction',
            },
            {
              label: 'Usage',
              to: 'docs/usage',
            },
            {
              label: 'Command Reference',
              to: 'docs/commands/New-DocusaurusHelp',
            },
          ],
        },
        {
          title: 'Community',
          items: [
            {
              label: 'Discord',
              href: 'https://discordapp.com/invite/docusaurus',
            },
          ],
        },
        {
          title: 'More',
          items: [
            {
              label: 'Github',
              href: 'https://github.com/alt3/Docusaurus.Powershell',
            },
          ],
        },
      ],
      copyright: `Copyright ©${new Date().getFullYear()} ALT3 B.V.`,
    },
  },
  presets: [
    [
      '@docusaurus/preset-classic',
      {
        docs: {
          path: 'docs',
          sidebarPath: require.resolve('./sidebars.js'),
          editUrl: 'https://github.com/alt3/Docusaurus.Powershell/edit/main/website',
        },
        theme: {
          customCss: require.resolve('./src/css/custom.css'),
        },
      },
    ],
  ],
  future: {
    experimental_faster: true, // Use new @docusaurus/faster features for faster build
    v4: {
      removeLegacyPostBuildHeadAttribute: true, // To support SSG worker threads (experimental_faster.ssgWorkerThreads)
    },
  }
};
