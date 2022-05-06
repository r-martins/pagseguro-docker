<?php
namespace RicardoMartins\SystemInfo\Block;

use Magento\Framework\App\ProductMetadataInterface;
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
    private $moduleResources;

    public function __construct(
        Template\Context $context, ProductMetadataInterface $magentoProductMeta,
    ResourceInterface $moduleResources, array $data = []
    ) {
        $this->magentoProductMeta = $magentoProductMeta;
        $this->moduleResources = $moduleResources;
        parent::__construct($context, $data);
    }

    public function getMagentoVersion()
    {
        return $this->magentoProductMeta->getName() . ' ' . $this->magentoProductMeta->getEdition() . ' '
            . $this->magentoProductMeta->getVersion();
    }

    public function getPagSeguroVersion()
    {
        return $this->moduleResources->getDbVersion('RicardoMartins_PagSeguro');
    }
}
