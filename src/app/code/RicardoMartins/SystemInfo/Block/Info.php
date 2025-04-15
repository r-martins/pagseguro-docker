<?php
namespace RicardoMartins\SystemInfo\Block;

use Magento\Framework\App\ProductMetadataInterface;
use Magento\Framework\Component\ComponentRegistrarInterface;
use Magento\Framework\Exception\FileSystemException;
use Magento\Framework\Exception\ValidatorException;
use Magento\Framework\Filesystem\Directory\ReadFactory;
use Magento\Framework\Module\ModuleListInterface;
use Magento\Framework\Module\ResourceInterface;
use Magento\Framework\View\Element\Template;

class Info extends Template
{
    protected $_template = 'RicardoMartins_SystemInfo::info.phtml';
    /**
     * @var Magento\Framework\App\ProductMetadataInterface
     */
    private $magentoProductMeta;
    /**
     * @var \RicardoMartins\PagSeguro\Model\Config\Version
     */
    private ComponentRegistrarInterface $componentRegistrar;
    private ReadFactory $readFactory;

    public function __construct(
        Template\Context $context,
        ProductMetadataInterface $magentoProductMeta,
        ComponentRegistrarInterface $componentRegistrar,
        ReadFactory $readFactory,
        array $data = []
    ) {
        $this->magentoProductMeta = $magentoProductMeta;
        $this->componentRegistrar = $componentRegistrar;
        $this->readFactory = $readFactory;
        parent::__construct($context, $data);
    }

    public function getMagentoVersion()
    {
        return $this->magentoProductMeta->getName() . ' ' . $this->magentoProductMeta->getEdition() . ' '
            . $this->magentoProductMeta->getVersion();
    }

    public function getPagSeguroVersion():string
    {
        // Get the module's path
        $path = $this->componentRegistrar->getPath(\Magento\Framework\Component\ComponentRegistrar::MODULE, 'RicardoMartins_PagBank');

        // Read the composer.json file
        $directoryRead = $this->readFactory->create($path);
        try {
            if ($directoryRead->isFile('composer.json')) {
                $composerJsonData = $directoryRead->readFile('composer.json');
                $data = json_decode($composerJsonData, true);

                // Return the version if it exists in composer.json
                return $data['version'] ?? '';
            }
        } catch (\Exception $e) {
            return '';
        }

        return ''; // Return null if composer.json or version is not found
    }
}
